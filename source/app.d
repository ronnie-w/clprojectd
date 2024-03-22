import std.stdio : writeln;
import std.file : mkdir, write, exists, FileException;
import std.string : indexOf, strip, replace;
import core.stdc.stdlib : exit;

import utils.fs : EmbeddedFiles;
import utils.prompt : promptRequest, ProjectDetails;

void initProject()
{
    ProjectDetails* project = new ProjectDetails();
    promptRequest(project);

    string projectName = project.projectName.strip;
    try
        if (!projectName.exists)
            projectName.mkdir;
        else
        {
            writeln("Project '" ~ projectName ~ "' already exists. Quitting...");
            exit(-1);
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

void main(string[] args)
{
    // dfmt off
    alias help = () => writeln(`Usage: cld <options>
	where <options> are:
		init:	initialize a basic common lisp project
		help:	prints this message
	use:
		'make build':	to build an executable
		'make run'  :	to run the project in development mode (starts REPL, use '(quit)' to exit REPL)
	to use a different lisp implementation, change the 'make' LISP variable
		eg: 'make build LISP=<installed lisp implementation>'`);
	// dfmt on

    if (args.length < 2)
        help();
    else
    {
        switch (args[1])
        {
        case "init":
            initProject();
            break;
        case "help":
            goto default;
        default:
            help();
            break;
        }
    }
}
