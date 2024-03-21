module utils.prompt;

import std.stdio : stdin, readf, writef;

struct ProjectDetails
{
    string projectName = "clproject", projectVersion = "0.0.1", projectAuthor,
        projectLicense = "proprietary",
        projectDescription = "a minimal common lisp application";
}

struct Prompter
{
    string prompt;
    string* promptVar;
}

void promptRequest(ProjectDetails* project)
{
    void checkEmpty(string prompt, string* defaultVal)
    {
        string valCpy = *defaultVal;
        writef(prompt, *defaultVal);
        stdin.readf("%s\n", defaultVal);
        if (defaultVal.length == 0)
            *defaultVal = valCpy;
    }

    Prompter[] prompts = [
        Prompter("project name [%s]: ", &project.projectName),
        Prompter("version [%s]: ", &project.projectVersion),
        Prompter("author [%s]: ", &project.projectAuthor),
        Prompter("license [%s]: ", &project.projectLicense),
        Prompter("description [%s]: ", &project.projectDescription),
    ];

    for (int i = 0; i < prompts.length; i++)
        checkEmpty(prompts[i].prompt, prompts[i].promptVar);
}
