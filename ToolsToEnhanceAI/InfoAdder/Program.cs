
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FileInterraction;
using WebInterraction;
using PalConvertion;

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
            List<string> outfiledata_rawA = new List<string>(); //just results without any modafcation wich will be needed
            List<string> outfiledata_rawB = new List<string>();
            List<string> outfiledata_rawC = new List<string>();
            List<string> outfiledata_rawD = new List<string>();
            List<string> outfiledata_rawE = new List<string>();
            List<string> outfiledata = new List<string>(); //just results without any modafcation wich will be needed
            List<string> blockedlinkes = new List<string>();

            WebCollect.LoadBrowser();
            List<WebNode> scrapenodes = new List<WebNode>(); //content we want it to search for
            scrapenodes.Add(new WebNode("div", "class", "q-box spacing_log_answer_content puppeteer_test_answer_content", -1));

            blockedlinkes.Add("https://www.quora.com/about");
            blockedlinkes.Add("https://www.quora.com/careers");
            blockedlinkes.Add("https://www.quora.com/contact");
            blockedlinkes.Add("https://www.quora.com/press");
            blockedlinkes.Add("https://www.quora.com/profile");

            WebCollect.SetWebScrapeNodes(scrapenodes); //since all the searches will be done on google we will only need to do this once

            int old_percentage = 0;

            for (int i = 0; i < infiledata.Count; i++)
            {
                int new_percentage = (int)((double)((double)i / infiledata.Count) *100);
                if (new_percentage > old_percentage)
                {
                    old_percentage = new_percentage;
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine($"current compleation percentage %{new_percentage}");
                    Console.ResetColor();
                }

                WebCollect.SetWebTarget(WebCollect.ConvertToSearchForQuoraURL(infiledata[i]));

                List<string> ress = WebCollect.CollectLinks();
                string res = "";

                for (int j = 0; j < 100; j++)
                {
                    foreach (string result in ress)
                    {
                        bool blockresult = false;
                        foreach (string blocked in blockedlinkes) { if (result.Contains(blocked) == true || result == "https://www.quora.com/") { blockresult = true; break; }; }
                        if (blockresult == false) { res = result; break; }
                    }
                    if (res != "") { break; }
                    Thread.Sleep(100);
                }
                if (res == "" && ress.Count > 0) { res = ress[ress.Count -1]; }

                if (res != "")
                {
                    WebCollect.SetWebTarget(res);
                    List<string> collectionpoint = WebCollect.Collect();
                    if (collectionpoint.Count >= 3 && collectionpoint[0] != "" && collectionpoint[1] != "" && collectionpoint[2] != "")
                    {
                        outfiledata_rawA.Add(collectionpoint[0]); //we need to make sure the outfile data and infile data = the same
                        outfiledata_rawB.Add(collectionpoint[1]);
                        outfiledata_rawC.Add(collectionpoint[2]);
                    }
                    else
                    {
                        outfiledata_rawA.Add("NULL");
                        outfiledata_rawB.Add("NULL");
                        outfiledata_rawC.Add("NULL");
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine($"error item [{i}/{infiledata[i]}] could not be processed as suficent sample size could not be for pal could not be found");
                        Console.ResetColor();
                    }

                    if (collectionpoint.Count >= 5 && collectionpoint[3] != "" && collectionpoint[4] != "")
                    {
                        outfiledata_rawD.Add(collectionpoint[3]); //we need to make sure the outfile data and infile data = the same
                        outfiledata_rawE.Add(collectionpoint[4]);
                    }
                    else
                    {
                        outfiledata_rawD.Add("NULL");
                        outfiledata_rawE.Add("NULL");
                    }
                }
                else 
                {
                    outfiledata_rawA.Add("NULL");
                    outfiledata_rawB.Add("NULL");
                    outfiledata_rawC.Add("NULL");
                    outfiledata_rawD.Add("NULL");
                    outfiledata_rawE.Add("NULL");

                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine($"error item [{i}/{infiledata[i]}] find faliure");
                    Console.ResetColor();
                }

            }

            for (int i = 0; i < outfiledata_rawA.Count; i++)
            {
                if (outfiledata_rawA[i] != "NULL")
                {
                    string q = infiledata[i];
                    List<string> a = new List<string>();
                    a.Add(outfiledata_rawA[i]);
                    a.Add(outfiledata_rawB[i]);
                    a.Add(outfiledata_rawC[i]);

                    if (outfiledata_rawD[i] != "NULL") { a.Add(outfiledata_rawD[i]);a.Add(outfiledata_rawE[i]);};

                    if (a.Count != 0)
                    {
                        outfiledata.Add(Pal.ConvetToPalData(q, a));
                    }

                }
            }

            FileModify.SetFilePath(outfile);
            FileModify.SetFileData(outfiledata);
            Console.WriteLine("Done!!!");
        }
    }
}
