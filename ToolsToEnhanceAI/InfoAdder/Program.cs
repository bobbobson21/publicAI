
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

            WebCollect.LoadBrowser();
            List<WebNode> scrapenodes = new List<WebNode>(); //content we want it to search for
            scrapenodes.Add(new WebNode("div", "class", "q-box spacing_log_answer_content puppeteer_test_answer_content", -1));

            WebCollect.SetWebScrapeNodes(scrapenodes); //since all the searches will be done on google we will only need to do this once

            for (int i = 0; i < infiledata.Count; i++)
            {
                WebCollect.SetWebTarget(WebCollect.ConvertToSearchForQuoraURL(infiledata[i]));
                string res = WebCollect.CollectLinks()[2];
                WebCollect.SetWebTarget(res);
                List<string> collectionpoint = WebCollect.Collect();
                if (collectionpoint.Count >= 3)
                {
                    outfiledata_rawA.Add( collectionpoint[0] ); //we need to make sure the outfile data and infile data = the same
                    outfiledata_rawB.Add( collectionpoint[1] );
                    outfiledata_rawC.Add( collectionpoint[2] );
                }
                else 
                {
                    outfiledata_rawA.Add( "NULL" );
                    Console.WriteLine( $"error item {i}/{infiledata[i]} could not be processed as suficent sample size could not be for pal could not be found" );
                }

                if (collectionpoint.Count >= 5)
                {
                    outfiledata_rawD.Add(collectionpoint[3]); //we need to make sure the outfile data and infile data = the same
                    outfiledata_rawE.Add(collectionpoint[4]);
                }
                else
                {
                    outfiledata_rawD.Add("NULL");
                }

            }

            for (int i = 0; i < infiledata.Count; i++)
            {
                if (outfiledata_rawA[i] != "NULL")
                {
                    string q = infiledata[i];
                    List<string> a = new List<string>();
                    a.Add(outfiledata_rawA[i]);
                    a.Add(outfiledata_rawB[i]);
                    a.Add(outfiledata_rawC[i]);

                    if (outfiledata_rawD[i] != "NULL") { a.Add(outfiledata_rawD[i]);a.Add(outfiledata_rawE[i]);};

                    outfiledata.Add(Pal.ConvetToPalData(q, a));

                }
            }

            FileModify.SetFilePath(outfile);
            FileModify.SetFileData(outfiledata);
            Console.WriteLine("Done!!!");
        }
    }
}
