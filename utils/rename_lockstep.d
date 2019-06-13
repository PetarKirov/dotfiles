import std.array, std.algorithm, std.format, std.getopt, std.file, std.path, std.range, std.regex, std.stdio;

// Sample usage:

// rdmd rename_lockstep.d --dir="$(cygpath -w "$(pwd)")" \
//   --follow-ext=mkv,mp4 --rename-ext=sub,srt \
//   --follow-regex='.*[sS]0*([0-9]+)[eE]0*([0-9]+)' \
//   --rename-regex='.*0*([0-9]+)x0*([0-9]+)' \
//   --dry-run=true

void main(string[] args)
{
    bool dryRun = true;
    string dir;
    string[] followExt;
    string[] renameExt;

    string followRegex;
    string renameRegex;

    arraySep = ",";
    getopt(args,
        "dir", &dir,
        "follow-ext", &followExt,
        "rename-ext", &renameExt,
        "follow-regex", &followRegex,
        "rename-regex", &renameRegex,
        "dry-run", &dryRun
    );

    string followGlob = "*.{%-(%s,%)}".format(followExt);
    string renameGlob = "*.{%-(%s,%)}".format(renameExt);

    auto filesToFollow = dir.dirEntries(followGlob, SpanMode.shallow).map!(f => f.name).array;
    auto filesToRename = dir.dirEntries(renameGlob, SpanMode.shallow).map!(r => r.name).array;

    "Renaming '%s' following '%s' in '%s'.".writefln(renameGlob, followGlob, dir);
    "Follow regex: '%s' | rename regex: '%s'".writefln(followRegex, renameRegex);

    assert(filesToFollow.length == filesToRename.length);

    foreach (f; filesToFollow)
    {
        auto name = f.baseName;
        auto fm = name.matchFirst(followRegex).dropOne.array;
        auto r = filesToRename.find!(r => r.baseName.matchFirst(renameRegex).skip1.equal(fm));

        auto src = r.front;
        auto dst = name.setExtension(src.extension);

        writefln("%s => %s\n", src.baseName, dst.baseName);

        if (!dryRun)
            src.rename(dst);
    }
}

auto skip1(R)(auto ref R r)
{
    return r.empty ? r : r.dropOne;
}