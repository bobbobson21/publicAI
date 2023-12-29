using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HtmlAgilityPack;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Chromium;

namespace WebInterraction
{
    class WebCollect
    {
        private static string TargetSite = ""; //locks onto site
        public static void SetWebTarget(string Str) {TargetSite = Str;}
        public static string GetWebTarget() {return TargetSite;}

        private static List<WebNode> TargetData = new List<WebNode>(); //locks onto data with in site
        public static void SetWebScrapeNodes(List<WebNode> Str) { TargetData = Str; }
        public static List<WebNode> GetWebScrapeNodes() {return TargetData;}

        private static int MaxCollectionAttemnpts = 5; //locks onto site
        public static void SetMaxCollectionAttempts(int Attempts) { MaxCollectionAttemnpts = Attempts; }
        public static int GetMaxCollectionAttempts() { return MaxCollectionAttemnpts; }

        private static ChromeOptions BroOptions;
        private static ChromeDriver BroDriver;

        public static void LoadBrowser()
        {
            BroOptions = new ChromeOptions();
            BroOptions.AddArgument( "disable-logging" );
            BroOptions.AddArguments("mute-audio");
            BroOptions.AddArguments("disable-extensions");
            BroOptions.AddArguments("headless");
            BroDriver = new ChromeDriver(BroOptions);
        }

        public static string ConvertToSearchURL(string Url)
        {
            Url = Url.Replace(" ", "+");
            Url = "https://www.google.com/search?q=" + Url; //who uses bing other than for bing bot
            return Url;
        }

        public static string ConvertToSearchForQuoraURL(string Url)
        {
            Url = Url.Replace(" ", "%20");
            Url = "https://www.quora.com/search?q=" + Url; //easiest site to extract awnsers from
            return Url;
        }

        public static List<string> CollectLinks()
        {
            var CodeHtmlData = new HtmlDocument();

            while (true)
            {
                try
                {
                    BroDriver.Navigate().GoToUrl(TargetSite);
                    break;
                }
                catch {Thread.Sleep(30000);}
            }

            while (true)
            {
                try
                {
                    CodeHtmlData.LoadHtml(BroDriver.PageSource);
                    break;
                }
                catch { Thread.Sleep(30000); }
            }

            List<string> LinksOut = new List<string>();
            List<HtmlNode> LinkBoxesA = new List<HtmlNode>();
            List<HtmlNode> LinkBoxesB = new List<HtmlNode>();
            List<HtmlNode> LinkBoxesC = new List<HtmlNode>();

            for (int I = 0; I <= MaxCollectionAttemnpts; I++)
            {
                try { LinkBoxesA = CodeHtmlData.DocumentNode.SelectNodes("//a").ToList(); I = MaxCollectionAttemnpts + 10; } catch { };
                try { LinkBoxesB = CodeHtmlData.DocumentNode.SelectNodes("//div").ToList(); } catch { };
                try { LinkBoxesC = CodeHtmlData.DocumentNode.SelectNodes("//Link").ToList(); } catch { };
            }

            foreach (var LinkBox in LinkBoxesA)
            {
                string Link = LinkBox.GetAttributeValue("href", "NULL");
                if (Link != "NULL") { LinksOut.Add(Link.ToString()); }
            }
            foreach (var LinkBox in LinkBoxesB)
            {
                string Link = LinkBox.GetAttributeValue("href", "NULL");
                if (Link != "NULL") { LinksOut.Add(Link.ToString()); }
            }
            foreach (var LinkBox in LinkBoxesC)
            {
                string Link = LinkBox.GetAttributeValue("href", "NULL");
                if (Link != "NULL") { LinksOut.Add(Link.ToString()); }
            }
            return LinksOut;
        }


        public static List<string> Collect() //fire and grab the bounty
        {
            List<string> ExtractedData = new List<string>();
            var CodeHtmlData = new HtmlDocument();

            while (true)
            {
                try
                {
                    BroDriver.Navigate().GoToUrl(TargetSite);
                    break;
                }
                catch { Thread.Sleep(30000); }
            }

            while (true)
            {
                try
                {
                    CodeHtmlData.LoadHtml(BroDriver.PageSource);
                    break;
                }
                catch { Thread.Sleep(30000); }
            }

            foreach (WebNode Point in TargetData)
            {
                List<HtmlNode> Nodes = new List<HtmlNode>();

                for (int I = 0; I <= MaxCollectionAttemnpts; I++)
                {
                    try { Nodes = CodeHtmlData.DocumentNode.SelectNodes(Point.Output()).ToList(); I = MaxCollectionAttemnpts + 10; } catch { };
                }

                foreach(HtmlNode Node in Nodes)
                {
                    if (Point.OutputChildIndex() >= 0) { ExtractedData.Add(Node.ChildNodes[Point.OutputChildIndex()].InnerText); }
                    if (Point.OutputChildIndex() <= -1) { ExtractedData.Add(Node.InnerText); }
                }
            }
            return ExtractedData;
        }
    }

    public class WebNode
    {
        private string W_Type = "";
        private string W_Key = "";
        private string W_Value = "";
        private int W_Child = -1;
        
        public WebNode(string type, string key, string value, int childindex )
        {
            W_Type = type; W_Key = key; W_Value = value;
        }

        public int OutputChildIndex() 
        {
            return W_Child;
        }

        public string Output()
        {
            return $"//{W_Type}[@{W_Key}='{W_Value}']";
        }
    }
}
