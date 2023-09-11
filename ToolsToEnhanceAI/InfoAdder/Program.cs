
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

            FileModify.SetFilePath( infile );
            List<string> infiledata = FileModify.GetFileData();
            List<string> outfiledata_rawA = new List<string>(); //just results without any modafcation wich will be needed
            List<string> outfiledata_rawB = new List<string>();
            List<string> outfiledata_rawC = new List<string>();
            List<string> outfiledata_rawD = new List<string>();
            List<string> outfiledata_rawE = new List<string>();
            List<string> outfiledata = new List<string>(); //just results without any modafcation wich will be needed

            List<WebNode> scrapenodes = new List<WebNode>(); //content we want it to search for
            scrapenodes.Add(new WebNode("div", "class", "q-box spacing_log_answer_content puppeteer_test_answer_content"));

            WebCollect.SetWebScrapeNodes(scrapenodes); //since all the searches will be done on google we will only need to do this once

            for (int i = 0; i < infiledata.Count; i++)
            {
                WebCollect.SetWebTarget(WebCollect.ConvertToSearchForQuoraURL(infiledata[i]));
                WebCollect.SetWebTarget(WebCollect.CollectLinks()[7]);
                outfiledata_rawA[i] = WebCollect.Collect()[1]; //we need to make sure the outfile data and infile data = the same
                outfiledata_rawB[i] = WebCollect.Collect()[2];
                outfiledata_rawC[i] = WebCollect.Collect()[3];
                outfiledata_rawD[i] = WebCollect.Collect()[4];
                outfiledata_rawE[i] = WebCollect.Collect()[5];
            }

            for( int i = 0; i < infiledata.Count; i++ )
            {
                string q = infiledata[i];
                string a = outfiledata_rawA[i]+","+ outfiledata_rawB[i]+","+outfiledata_rawC[i]+","+outfiledata_rawD[i]+","+outfiledata_rawE[i];

                outfiledata.Add( Pal.ConvetToPalData( q, a ) );
            }

            FileModify.SetFilePath(outfile);
            FileModify.SetFileData(outfiledata);
            Console.WriteLine("Done!!!");
        }
    }

}
