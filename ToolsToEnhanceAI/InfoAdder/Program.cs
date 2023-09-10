
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FileInterraction;
using WebInterraction;

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

            FileModify.SetFilePath( infile );
            List<string> infiledata = FileModify.GetFileData();
            List<string> outfiledata_raw = new List<string>(); //just results without any modafcation wich will be needed

            List<WebNode> scrapenodes = new List<WebNode>(); //content we want it to search for
            scrapenodes.Add(new WebNode("div", "class", "q-box spacing_log_answer_content puppeteer_test_answer_content"));

            WebCollect.SetWebScrapeNodes(scrapenodes); //since all the searches will be done on google we will only need to do this once

            foreach( string line in infiledata)
            {
                WebCollect.SetWebTarget(WebCollect.ConvertToSearchForQuoraURL(line));
                WebCollect.SetWebTarget(WebCollect.CollectLinks()[1]); //MAY NEED TO CHANGE INDEX CHECK RESULT FIRST
                outfiledata_raw.Concat( WebCollect.Collect() );


            }

        }
    }

}
