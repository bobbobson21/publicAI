using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Drawing;
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
        private static string targetsite = ""; //locks onto site
        public static void SetWebTarget(string str) {targetsite = str;}
        public static string GetWebTarget() {return targetsite;}

        private static List<WebNode> targetdata = new List<WebNode>(); //locks onto data with in site
        public static void SetWebScrapeNodes(List<WebNode> str) { targetdata = str; }
        public static List<WebNode> GetWebScrapeNodes() {return targetdata;}

        private static int maxcollectionattemnpts = 5; //locks onto site
        public static void SetMaxCollectionAttempts(int att) { maxcollectionattemnpts = att; }
        public static int GetMaxCollectionAttempts() { return maxcollectionattemnpts; }

        private static ChromeOptions bro_options;
        private static ChromeDriver bro_driver;

        public static void LoadBrowser()
        {
            bro_options = new ChromeOptions();
            bro_options.AddArgument( "disable-logging" );
            bro_options.AddArguments("mute-audio");
            bro_options.AddArguments("disable-extensions");
            bro_options.AddArguments("headless");
            bro_driver = new ChromeDriver(bro_options);
        }

        public static string ConvertToSearchURL(string url)
        {
            url = url.Replace(" ", "+");
            url = "https://www.google.com/search?q=" + url; //who uses bing other than for bing bot
            return url;
        }

        public static string ConvertToSearchForQuoraURL(string url)
        {
            url = url.Replace(" ", "%20");
            url = "https://www.quora.com/search?q=" + url; //easiest site to extract awnsers from
            return url;
        }

        public static List<string> CollectLinks()
        {   
            bro_driver.Navigate().GoToUrl(targetsite);
            var code_htmldata = new HtmlDocument();
            code_htmldata.LoadHtml(bro_driver.PageSource);
            List<string> linksstr = new List<string>();
            List<HtmlNode> linkboxesA = new List<HtmlNode>();
            List<HtmlNode> linkboxesB = new List<HtmlNode>();
            List<HtmlNode> linkboxesC = new List<HtmlNode>();

            for (int i = 0; i <= maxcollectionattemnpts; i++)
            {
                try { linkboxesA = code_htmldata.DocumentNode.SelectNodes("//a").ToList(); i = maxcollectionattemnpts + 10; } catch { };
                try { linkboxesB = code_htmldata.DocumentNode.SelectNodes("//div").ToList(); } catch { };
                try { linkboxesC = code_htmldata.DocumentNode.SelectNodes("//link").ToList(); } catch { };
            }

            foreach (var linkbox in linkboxesA)
            {
                string link = linkbox.GetAttributeValue("href", "NULL");
                if (link != "NULL") { linksstr.Add(link.ToString()); }
            }
            foreach (var linkbox in linkboxesB)
            {
                string link = linkbox.GetAttributeValue("href", "NULL");
                if (link != "NULL") { linksstr.Add(link.ToString()); }
            }
            foreach (var linkbox in linkboxesC)
            {
                string link = linkbox.GetAttributeValue("href", "NULL");
                if (link != "NULL") { linksstr.Add(link.ToString()); }
            }
            return linksstr;
        }


        public static List<string> Collect() //fire and grab the bounty
        {
            List<string> extracteddata = new List<string>();
            bro_driver.Navigate().GoToUrl(targetsite);
            var code_htmldata = new HtmlDocument();
            code_htmldata.LoadHtml(bro_driver.PageSource);

            foreach (WebNode Point in targetdata )
            {
                List<HtmlNode> nodes = new List<HtmlNode>();

                for (int i = 0; i <= maxcollectionattemnpts; i++)
                {
                    try { nodes = code_htmldata.DocumentNode.SelectNodes(Point.Output()).ToList(); i = maxcollectionattemnpts + 10; } catch { };
                }

                foreach(HtmlNode node in nodes)
                {
                    if (Point.OutputChildIndex() >= 0) { extracteddata.Add(node.ChildNodes[Point.OutputChildIndex()].InnerText); }
                    if (Point.OutputChildIndex() <= -1) { extracteddata.Add(node.InnerText); }
                }
            }
            return extracteddata;
        }
    }

    public class WebNode
    {
        private string w_type = "";
        private string w_key = "";
        private string w_value = "";
        private int w_child = -1;
        
        public WebNode(string type, string key, string value, int childindex )
        {
            w_type = type; w_key = key; w_value = value;
        }

        public int OutputChildIndex() 
        {
            return w_child;
        }

        public string Output()
        {
            return $"//{w_type}[@{w_key}='{w_value}']";
        }
    }
}
