#!/usr/bin/env rdmd

static import std.getopt;
import std.exception : enforce;
import std.stdio : writeln;

void main(string[] args)
{
    bool push = false;
    string remote;
    string repo;
    string[] branchChain;

    std.getopt.arraySep = ",";
    std.getopt.getopt(
        args,
        "push", &push,
        "remote", &remote,
        std.getopt.config.required, "repo", &repo,
        std.getopt.config.required, "branch-chain", &branchChain
    );

    enforce(branchChain.length >= 2,
        "A chain of at least 2 branches is needed.");

    string baseBranch = branchChain[0];

    foreach (branchToRebase; branchChain[1 .. $])
    {
        gitCheckout(repo, branchToRebase);
        gitRebase(repo, baseBranch);
        if (push) gitForcePush(repo, remote);
        baseBranch = branchToRebase;
    }
}

void gitCheckout(string repoPath, string branchName)
{
    runGit(repoPath, ["checkout", branchName]);
}

void gitRebase(string repoPath, string baseBranch)
{
    runGit(repoPath, ["rebase", baseBranch]);
}

void gitForcePush(string repoPath, string remote)
{
    runGit(repoPath, ["push", "-f"].addIfNotNull(remote));
}

void runGit(string repoPath, string[] args)
{
    import std.process : spawnProcess, wait;
    repoPath.isValidGitDir.enforce;
    auto cmd = ["git", "-c", "color.status=always", "-C", repoPath] ~ args;
    "> ".writeln(cmd);
    cmd
        .spawnProcess
        .wait
        .enforceZeroStatus;
}

bool isValidGitDir(string repoPath)
{
    import std.process : execute;
    return ["git", "-C", repoPath, "rev-parse", "--is-inside-work-tree"]
        .execute
        .status == 0;
}

auto enforceZeroStatus(int status)
{
    return enforce(status == 0);
}

T[] addIfNotNull(T)(T[] array, T element)
{
    static if (is(T : U[], U))
        bool empty = !element.length || !element.ptr;
    else
        bool empty = !element;

    return empty? array : array ~ element;
}
