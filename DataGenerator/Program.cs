using System;
using System.Net;
using CsvHelper;

string infile = "../SkillLineAbility.csv";
string outfile = "../ProfessionsSkillUp/Data.lua";

//WebClient webClient = new WebClient();
//webClient.DownloadFile("https://wago.tools/db2/SkillLineAbility/csv", infile);

using var reader = new StreamReader(infile);
using var csv = new CsvReader(reader, System.Globalization.CultureInfo.InvariantCulture);
using var writer = new StreamWriter(outfile);

writer.WriteLine("local addonName, addonTable = ...");
writer.WriteLine("addonTable.Data = {");

var dict = new Dictionary<ulong, string>();

csv.Read();
csv.ReadHeader();
while (csv.Read())
{
    var spell = csv.GetField<ulong>("Spell");
    var red = csv.GetField<ulong>("MinSkillLineRank");
    var yellow = csv.GetField<ulong>("TrivialSkillLineRankLow");
    var gray = csv.GetField<ulong>("TrivialSkillLineRankHigh");
    var green = (yellow + gray) / 2;

    var skillUpSrc = $"{red}/{yellow}/{green}/{gray}";

    if (dict.TryGetValue(spell, out var existing))
    {
        if (existing != skillUpSrc)
        {
            Console.WriteLine($"Conflict for spell {spell}: {existing} vs {skillUpSrc}");
        }
        continue;
    }

    dict[spell] = skillUpSrc;
    writer.WriteLine($"[{spell}]='{skillUpSrc}',");
}

writer.WriteLine("}");

Console.WriteLine($"all: {dict.Count}");
