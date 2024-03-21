import std.stdio : writeln;
import std.file : mkdir, write, exists, FileException;
import std.string : indexOf, strip, replace;
import core.stdc.stdlib : exit;

import utils.fs : EmbeddedFiles;
import utils.prompt : promptRequest, ProjectDetails;

void main(string[] args)
{
    ProjectDetails* project = new ProjectDetails();
    promptRequest(project);

    string projectName = project.projectName.strip;
    try
    {
        if (!projectName.exists)
            projectName.mkdir;
    }
    catch (FileException e)
    {
        writeln("Could not initialize project.");
        exit(-1);
    }

    for (int i = 0; i < EmbeddedFiles.length; i++)
    {
        if (EmbeddedFiles[i].fileName.indexOf("src") > -1)
            mkdir(projectName ~ "/src");
        else if (EmbeddedFiles[i].fileName.indexOf("default.asd") > -1)
            EmbeddedFiles[i].fileName = projectName ~ ".asd";

        // dfmt off
        string parsedData = EmbeddedFiles[i].fileData
			.replace(`{%project-name%}`, projectName)
			.replace(`{%project-version%}`, project.projectVersion)
            .replace(`{%project-author%}`, project.projectAuthor)
			.replace(`{%project-license%}`, project.projectLicense)
			.replace(`{%project-description%}`, project.projectDescription);
		// dfmt on

        (projectName ~ "/" ~ EmbeddedFiles[i].fileName).write(parsedData);
    }
}
