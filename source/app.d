import std.stdio : writeln;
import std.file : mkdir, write, exists, getcwd, FileException;
import std.string : indexOf, strip, replace, split;
import core.stdc.stdlib : exit;

import utils.fs : EmbeddedFiles, embeddedCompose;
import utils.prompt : promptRequest, ProjectDetails;

string initProject()
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

    return projectName;
}

void composeFile(string projectName, string fileName)
{
    string composedFilepath = embeddedCompose.fileName.replace(
            `{%project-compose%}`, fileName),
        composedFile = embeddedCompose.fileData.replace(`{%project-compose%}`,
                fileName).replace(`{%project-name%}`, projectName);

    composedFilepath.write(composedFile);
}

void main(string[] args)
{
    // dfmt off
    alias help = () => writeln(`Usage: cld <options>
	where <options> are:
		init:	 initialize a basic common lisp project
		compose: compose new common lisp files in project with 'boilerplate'
		help:	 prints this message
	use:
		'make build':			to build an executable
		'make run'  :			to run the project in development mode (starts REPL, use '(quit)' to exit REPL)
		'compose <filename>':	to create a file in src folder
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
        case "compose":
            string currentDir = getcwd.split("/")[$ - 1];
            if (!(currentDir ~ ".asd").exists)
            {
                writeln("Run compose in the project root directory. Quitting...");
                exit(-1);
            }
            else if (args.length < 3)
            {
                writeln("Nothing to compose, try adding a filename?. Quitting...");
                goto default;
            }
            composeFile(currentDir, args[2]);
            break;
        case "help":
            goto default;
        default:
            help();
            break;
        }
    }
}
