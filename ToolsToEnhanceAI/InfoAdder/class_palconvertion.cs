using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PalConvertion
{
    class Pal
    {
        private static string[] HateAnger = {"annoying","problmatic","horrible","mean","pest","bad","fucker","cunt","dick","bitch","ass","douch",}; //we only care about four emotions because the emotion pointer can land on any point between them
        private static string[] hateCalm = {"annoying","problmatic","horrible","mean","pesting","bad","fucker","cunt","dick","bitch","ass","douch",};
        private static string[] loveCalm = {"lovely","kind","helpful","love","good","caring",};
        private static string[] loveAnger = {"lovely","kind","helpful","lovely","good","caring","annoying","problmatic","horrible","mean","pesting","bad","disappointment",};
        private static string[] RemoveFromQTags = {"is","the","think","thougth","to","get"};

        public static double[] CalulateEmotion( string scan, double emul )
        {
            double[] emot = { 0,0 };

            foreach (string str in HateAnger) //checks to see if we should be angry by finding angry words and if we shold be
            {
                if (scan.Contains(str) == true) //angry it will do the angryness below
                {
                    emot[0] = emot[0] - emul;
                    emot[1] = emot[1] - emul;
                }

            }

            foreach (string str in hateCalm)
            {
                if (scan.Contains(str) == true)
                {
                    emot[0] = emot[0] + emul;
                    emot[1] = emot[1] - emul;
                }

            }

            foreach (string str in loveCalm)
            {
                if (scan.Contains(str) == true)
                {
                    emot[0] = emot[0] + emul;
                    emot[1] = emot[1] + emul;
                }

            }

            foreach (string str in loveAnger)
            {
                if (scan.Contains(str) == true)
                {
                    emot[0] = emot[0] - emul;
                    emot[1] = emot[1] + emul;
                }

            }

            if (emot[0] > 3) { emot[0] = 3; }; //clamping
            if (emot[1] > 3) { emot[1] = 3; };
            if (emot[0] < -3) { emot[0] = -3; };
            if (emot[1] < -3) { emot[1] = -3; };

            return emot;
        }

        public static string QTagRemoval( string q )
        {
            q = q + ",";
            foreach (string str in RemoveFromQTags)
            {
                q =  q.Replace(str+",", "");
            }
            q = q.Substring(0, q.Length-1);
            return q;
        }

        public static string QTagSimplfiy( string q )
        {
            q = q.Replace("people", "you");
            q = q.Replace("what's", "what");
            return q;
        }

        public static string QToNRTTags(string q)
        {
            string[] tags = q.Split(",");
            for (int i = 0; i < tags.Length; i++) { tags[i] = (char)34 + "|pal:NRT('" + tags[i] + "')|" + (char)34; };
            string result = string.Join( ",", tags );
            return result;
        }

        public static string ConvetToPalData( string q, List<string> a )
        {
            q = q.Replace("\n", " ");
            string newa = "";

            for (int i = 0; i < a.Count; i++)
            {
                a[i] = a[i].Replace("\n", " "); //how it responds to stuff should not have new lines 
                a[i] = a[i].Replace("|", "-");
                a[i] = a[i].Replace("'", "");
                a[i] = a[i].Replace( ((char)34).ToString(), "");
                newa = newa + (char)34 + a[i] + (char)34 +",";

            }

            double[] emotionlevel = CalulateEmotion( q+ newa, 0.25 );

            q = q.Replace(" ", ","); //turns words to tags
            q = QTagSimplfiy(q);
            q = QTagRemoval(q); //removes uneeded tags
            q = QToNRTTags(q);

            return "pal:SetNewInfo( {"+q+"}, nil, {"+ emotionlevel[0].ToString()+","+ emotionlevel[1].ToString()+"}, nil, nil, nil,{"+ newa + "}, nil, nil, nil )";
        }

    }
}
