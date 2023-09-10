using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HtmlAgilityPack;

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

        public static string ConvertToSearchURL(string url)
        {
            url.Replace(" ", "+");
            url = "https://www.google.com/search?q=" + url; //who uses bing other than for bing bot
            return url;
        }

        public static string ConvertToSearchForQuoraURL(string url)
        {
            url.Replace(" ", "%20");
            url = "https://www.quora.com/search?q=" + url; //easiest site to extract awnsers from
            return url;
        }

        public static List<string> CollectLinks()
        {
            var browser = new HttpClient(); //dose the searching
            var string_htmldata = browser.GetStringAsync(targetsite).Result; //gives us the file data
            var code_htmldata = new HtmlDocument();
            code_htmldata.LoadHtml(string_htmldata);
            List<string> linksstr = new List<string>();
            List<HtmlNode> linkboxes = code_htmldata.DocumentNode.SelectNodes("//a").ToList();
            linkboxes.Concat( code_htmldata.DocumentNode.SelectNodes("//div").ToList() );
            linkboxes.Concat( code_htmldata.DocumentNode.SelectNodes("//link").ToList() );


            foreach (var linkbox in linkboxes)
            {
                string link = linkbox.GetAttributeValue("herf", "NULL");
                if (link != "NULL") { linksstr.Add(link.ToString()); }
            }

            return linksstr;
        }


        public static List<string> Collect() //fire and grab the bounty
        {
            List<string> extracteddata = new List<string>();
            var browser = new HttpClient(); //dose the searching
            var string_htmldata = browser.GetStringAsync(targetsite).Result; //gives us the file data
            var code_htmldata = new HtmlDocument(); 
            code_htmldata.LoadHtml(string_htmldata); //takes the sting and runs the code in it

            foreach(WebNode Point in targetdata )
            {
                extracteddata.Add(code_htmldata.DocumentNode.SelectSingleNode(Point.Output()).InnerText);
                foreach ( HtmlNode child in code_htmldata.DocumentNode.SelectSingleNode(Point.Output()).ChildNodes)
                {
                    extracteddata.Add(child.InnerText);
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
        
        public WebNode(string type, string key, string value)
        {
            w_type = type; w_key = key; w_value = value;
        }

        public string Output()
        {
            return $"//{w_type}[@{w_key}='{w_value}']";
        }
    }
}
