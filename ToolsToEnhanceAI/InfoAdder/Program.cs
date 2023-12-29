
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
            string InFile = Console.ReadLine();
            Console.WriteLine("output to:");
            string OutFile = Console.ReadLine();

            FileModify.SetFilePath(InFile);
            List<string> InFiledata = FileModify.GetFileData();
            List<string> OutFileDataRawA = new List<string>(); //just results without any modafcation wich will be needed
            List<string> OutFileDataRawB = new List<string>();
            List<string> OutFileDataRawC = new List<string>();
            List<string> OutFileDataRawD = new List<string>();
            List<string> OutFileDataRawE = new List<string>();
            List<string> OutFileData = new List<string>(); //just results without any modafcation wich will be needed
            List<string> BlockedLinkes = new List<string>();

            WebCollect.LoadBrowser();
            List<WebNode> ScrapeNodes = new List<WebNode>(); //content we want it to search for
            ScrapeNodes.Add(new WebNode("div", "class", "Question-box spacing_log_answer_content puppeteer_test_answer_content", -1));

            BlockedLinkes.Add("https://www.quora.com/about");
            BlockedLinkes.Add("https://www.quora.com/careers");
            BlockedLinkes.Add("https://www.quora.com/contact");
            BlockedLinkes.Add("https://www.quora.com/pPossibleAwnsersToQuestion");
            BlockedLinkes.Add("https://www.quora.com/profile");

            WebCollect.SetWebScrapeNodes(ScrapeNodes); //since all the searches will be done on google we will only need to do this once

            int OldPercentage = 0;

            for (int I = 0; I < InFiledata.Count; I++)
            {
                int NewPercentage = (int)((double)((double)I / InFiledata.Count) *100);
                if (NewPercentage > OldPercentage)
                {
                    OldPercentage = NewPercentage;
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine($"current compleation percentage %{NewPercentage}");
                    Console.ResetColor();
                }

                WebCollect.SetWebTarget(WebCollect.ConvertToSearchForQuoraURL(InFiledata[I]));

                List<string> PossibleAwnsersToQuestion = WebCollect.CollectLinks();
                string ContainsAnAwnsersToQuestion = "";

                for (int j = 0; j < 100; j++)
                {
                    foreach (string Result in PossibleAwnsersToQuestion)
                    {
                        bool BlockResult = false;
                        foreach (string Blocked in BlockedLinkes) { if (Result.Contains(Blocked) == true || Result == "https://www.quora.com/") { BlockResult = true; break; }; }
                        if (BlockResult == false) { ContainsAnAwnsersToQuestion = Result; break; }
                    }
                    if (ContainsAnAwnsersToQuestion != "") { break; }
                    Thread.Sleep(100);
                }
                if (ContainsAnAwnsersToQuestion == "" && PossibleAwnsersToQuestion.Count > 0) { ContainsAnAwnsersToQuestion = PossibleAwnsersToQuestion[PossibleAwnsersToQuestion.Count -1]; }

                if (ContainsAnAwnsersToQuestion != "")
                {
                    WebCollect.SetWebTarget(ContainsAnAwnsersToQuestion);
                    List<string> CollectionOfAwnser = WebCollect.Collect();
                    if (CollectionOfAwnser.Count >= 3 && CollectionOfAwnser[0] != "" && CollectionOfAwnser[1] != "" && CollectionOfAwnser[2] != "")
                    {
                        OutFileDataRawA.Add(CollectionOfAwnser[0]); //we need to make sure the OutFile data and InFile data = the same
                        OutFileDataRawB.Add(CollectionOfAwnser[1]);
                        OutFileDataRawC.Add(CollectionOfAwnser[2]);
                    }
                    else
                    {
                        OutFileDataRawA.Add("NULL");
                        OutFileDataRawB.Add("NULL");
                        OutFileDataRawC.Add("NULL");
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine($"error item [{I}/{InFiledata[I]}] could not be processed as suficent sample size could not be for pal could not be found");
                        Console.ResetColor();
                    }

                    if (CollectionOfAwnser.Count >= 5 && CollectionOfAwnser[3] != "" && CollectionOfAwnser[4] != "")
                    {
                        OutFileDataRawD.Add(CollectionOfAwnser[3]); //we need to make sure the OutFile data and InFile data = the same
                        OutFileDataRawE.Add(CollectionOfAwnser[4]);
                    }
                    else
                    {
                        OutFileDataRawD.Add("NULL");
                        OutFileDataRawE.Add("NULL");
                    }
                }
                else 
                {
                    OutFileDataRawA.Add("NULL");
                    OutFileDataRawB.Add("NULL");
                    OutFileDataRawC.Add("NULL");
                    OutFileDataRawD.Add("NULL");
                    OutFileDataRawE.Add("NULL");

                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine($"error item [{I}/{InFiledata[I]}] find faliure");
                    Console.ResetColor();
                }

            }

            for (int I = 0; I < OutFileDataRawA.Count; I++)
            {
                if (OutFileDataRawA[I] != "NULL")
                {
                    string Question = InFiledata[I];
                    List<string> Awnsers = new List<string>();
                    Awnsers.Add(OutFileDataRawA[I]);
                    Awnsers.Add(OutFileDataRawB[I]);
                    Awnsers.Add(OutFileDataRawC[I]);

                    if (OutFileDataRawD[I] != "NULL") { Awnsers.Add(OutFileDataRawD[I]);Awnsers.Add(OutFileDataRawE[I]);};

                    if (Awnsers.Count != 0)
                    {
                        string data = Pal.ConvetToPalData(Question, Awnsers);
                        if (data != "NULL") { OutFileData.Add(data); };
                    }

                }
            }

            FileModify.SetFilePath(OutFile);
            FileModify.SetFileData(OutFileData);
            Console.ForegroundColor = ConsoleColor.Cyan;
            Console.WriteLine("Done!!!");
        }
    }
}
