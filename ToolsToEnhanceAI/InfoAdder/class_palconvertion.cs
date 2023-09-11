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
        private static string[] RemoveFromQTags = {"is","the",};

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
            if (emot[0] < 1) { emot[0] = 1; };
            if (emot[1] < 1) { emot[1] = 1; };

            return emot;
        }

        public static string QTagRemoval( string q )
        {
            q = q + ",";
            foreach (string str in RemoveFromQTags)
            {
                q.Replace(str+",", "");
            }
            q = q.Substring(0, q.Length-1);
            return q;
        }

        public static string QToNRTTags(string q)
        {
            string[] tags = q.Split(",");
            for (int i = 0; i < tags.Length; i++) { tags[i] = "|pal:NRT('" + tags[i] + "')|"; };
            string result = string.Join( ",", tags );
            return result;
        }

        public static string ConvetToPalData( string q, string a )
        {
            a = a.Replace("\n", " "); //how it responds to stuff should not have new lines
            q = q.Replace("\n", " ");

            double[] emotionlevel = CalulateEmotion( q+a, 0.25 );

            q = q.Replace(" ", ","); //turns words to tags
            q = QTagRemoval(q); //removes uneeded tags
            q = QToNRTTags(q);

            return "pal:SetNewInfo( {"+q+"}, nil, {"+ emotionlevel[0].ToString()+","+ emotionlevel[1].ToString()+"}, nil, nil, nil,{"+a+"}, nil, nil, nil )";
        }

    }
}
