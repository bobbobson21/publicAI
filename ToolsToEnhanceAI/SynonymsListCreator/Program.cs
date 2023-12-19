
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
            string infile = Console.ReadLine();
            Console.WriteLine("output to:");
            string outfile = Console.ReadLine();

            FileModify.SetFilePath(infile);
            List<string> infiledata = FileModify.GetFileData();
            List<string> outfiledata = new List<string>();

            WebCollect.LoadBrowser();

            List<WebNode> scrapenodes = new List<WebNode>(); //content we want it to search for
            scrapenodes.Add(new WebNode("a", "class", "text-decoration-none", -1));
            WebCollect.SetWebScrapeNodes(scrapenodes);

            int old_percentage = 0;

            for (int i = 0; i < infiledata.Count; i++)
            {

                int new_percentage = (int)((double)((double)i / infiledata.Count) * 100);
                if (new_percentage > old_percentage)
                {
                    old_percentage = new_percentage;
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine($"current compleation percentage %{new_percentage}");
                    Console.ResetColor();
                }

                WebCollect.SetWebTarget(WebCollect.ConvertToSearchForWebsterURL(infiledata[i]));
                List<string> data = WebCollect.Collect();
                string addline = "";

                if (data.Count >= 1)
                {
                    bool issmallfind = false;
                    for (int o = 0; o < data.Count && o < 4; o++)
                    {
                        string outtext = data[o].Replace("\r\n", "");
                        outtext = outtext.Replace(" ", "");
                        if (outtext.Length < 3) { issmallfind = true; }
                        addline = addline + infiledata[i] + "," + outtext + ",";
                    }

                    if (issmallfind == true)
                    {
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine($"error item [{i}/{infiledata[i]}] possibly dose not have good synonyms so it is discarded");
                        Console.ResetColor();
                    }
                    else
                    {
                        addline = addline.Substring(0, addline.Length - 1);
                        outfiledata.Add(addline);
                    }
                }
                else
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine($"error item [{i}/{infiledata[i]}] find faliure");
                    Console.ResetColor();
                }
            }

            FileModify.SetFilePath(outfile);
            FileModify.SetFileData(outfiledata);
            Console.ForegroundColor = ConsoleColor.Cyan;
            Console.WriteLine("Done!!!");
        }
    }
}
