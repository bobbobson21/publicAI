
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FileInterraction;
using WebInterraction;
using static System.Net.Mime.MediaTypeNames;

namespace program
{
    class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine($"starting from:{FileModify.CurrentDirectory}");
            Console.WriteLine("");
            Console.WriteLine("pull searches from:");
            string InFile = Console.ReadLine();
            Console.WriteLine("output to:");
            string OutFile = Console.ReadLine();

            FileModify.SetFilePath(InFile);
            List<string> InFileData = FileModify.GetFileData();
            List<string> OutFileData = new List<string>();

            WebCollect.LoadBrowser();

            List<WebNode> ScrapeNodes = new List<WebNode>(); //content we want it to search for
            ScrapeNodes.Add(new WebNode("a", "class", "text-decoration-none", -1));
            WebCollect.SetWebScrapeNodes(ScrapeNodes);

            int OldPercentage = 0;

            for (int I = 0; I < InFileData.Count; I++)
            {

                int NewPercentage = (int)((double)((double)I / InFileData.Count) * 100);
                if (NewPercentage > OldPercentage)
                {
                    OldPercentage = NewPercentage;
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine($"current compleation percentage %{NewPercentage}");
                    Console.ResetColor();
                }

                WebCollect.SetWebTarget(WebCollect.ConvertToSearchForWebsterURL(InFileData[I]));
                List<string> Data = WebCollect.Collect();

                if (Data.Count >= 1)
                {
                    string AddLine = InFileData[I] + ",";
                    int MinWordLength = 4;

                    if (InFileData[I].Length > MinWordLength)
                    {
                        for (int O = 0; O < Data.Count && O < 4; O++)
                        {
                            string OutText = Data[O].Replace("\r\n", "");
                            OutText = OutText.Replace(" ", "");

                            if ((OutText.Length > MinWordLength || OutText.Contains(InFileData[I][0]) == true) && OutText.Contains("(") == false && OutText.Contains(")") == false)
                            {
                                AddLine = AddLine + OutText + ",";
                            }
                        }
                    }

                    if (InFileData[I].Length > MinWordLength && AddLine != InFileData[I] + ",")
                    {
                        AddLine = AddLine.Substring(0, AddLine.Length - 1);
                        OutFileData.Add(AddLine);
                    }
                    else
                    {
                         Console.ForegroundColor = ConsoleColor.Red;
                         Console.WriteLine($"error item [{I}/{InFileData[I]}] possibly dose not have good synonyms so it is discarded");
                         Console.ResetColor();
                    }
                }
                else
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine($"error item [{I}/{InFileData[I]}] find faliure");
                    Console.ResetColor();
                }
            }

            FileModify.SetFilePath(OutFile);
            FileModify.SetFileData(OutFileData);
            Console.ForegroundColor = ConsoleColor.Cyan;
            Console.WriteLine("Done!!!");
        }
    }
}
