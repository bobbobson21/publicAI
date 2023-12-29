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
        private static string[] RemoveFromQTags = {"is","the","think","thougth","to","get","A"};
        private static string[] RemoveAIf = {"comment","comments","my"};

        public static double[] CalulateEmotion( string Scan, double EmotionMuliply )
        {
            double[] EmotionLevel = { 0,0 };

            foreach (string Str in HateAnger) //checks to see if we should be angry by finding angry words and if we shold be
            {
                if (Scan.Contains(Str) == true) //angry it will do the angryness below
                {
                    EmotionLevel[0] = EmotionLevel[0] - EmotionMuliply;
                    EmotionLevel[1] = EmotionLevel[1] - EmotionMuliply;
                }

            }

            foreach (string Str in hateCalm)
            {
                if (Scan.Contains(Str) == true)
                {
                    EmotionLevel[0] = EmotionLevel[0] + EmotionMuliply;
                    EmotionLevel[1] = EmotionLevel[1] - EmotionMuliply;
                }

            }

            foreach (string Str in loveCalm)
            {
                if (Scan.Contains(Str) == true)
                {
                    EmotionLevel[0] = EmotionLevel[0] + EmotionMuliply;
                    EmotionLevel[1] = EmotionLevel[1] + EmotionMuliply;
                }

            }

            foreach (string Str in loveAnger)
            {
                if (Scan.Contains(Str) == true)
                {
                    EmotionLevel[0] = EmotionLevel[0] - EmotionMuliply;
                    EmotionLevel[1] = EmotionLevel[1] + EmotionMuliply;
                }

            }

            if (EmotionLevel[0] > 3) { EmotionLevel[0] = 3; }; //clamping
            if (EmotionLevel[1] > 3) { EmotionLevel[1] = 3; };
            if (EmotionLevel[0] < 1) { EmotionLevel[0] = 1; };
            if (EmotionLevel[1] < 1) { EmotionLevel[1] = 1; };

            return EmotionLevel;
        }

        public static string QTagRemoval( string Q )
        {
            Q = Q + ",";
            foreach (string Str in RemoveFromQTags)
            {
                Q =  Q.Replace(Str+",", "");
            }
            Q = Q.Substring(0, Q.Length-1);
            return Q;
        }

        public static string QTagSimplfiy( string Q )
        {
            Q = Q.Replace("people", "you");
            Q = Q.Replace("what's", "what is");
            Q = Q.Replace("can't", "can not");
            Q = Q.Replace("what's", "what");
            return Q;
        }

        public static string QToNRTTags(string Q, int[] Skip)
        {
            string[] Tags = Q.Split(",");
            for (int I = 0; I < Tags.Length; I++)
            {
                if (Skip.Contains(I) == false)
                {
                    Tags[I] = (char)34 + "|pal:NRT('" + Tags[I] + "')|" + (char)34;
                }
                else
                {
                    Tags[I] = (char)34 + Tags[I] + (char)34;
                }
            }
            string Result = string.Join( ",", Tags );
            return Result;
        }

        public static bool ATextRemovealIf(string A) //returns A bool repasenting if A List<string> entry should be removed
        {
            bool AddCurrentResult = true;
            foreach (string check in RemoveAIf) //we dont want thing like I agree with the comnent above
            {
                if (A.Contains(check) == true)
                {
                    AddCurrentResult = false;
                }
            }
            return AddCurrentResult;
        }

        public static string ARemoveQuoraJargon(string A)
        {
            if (A.EndsWith("…(more)") == true && A.LastIndexOf(".") >= 1)
            {
                A = A.Substring(0, A.LastIndexOf(".") );     
            }
            return A;
        }


        public static string ConvetToPalData( string Q, List<string> A )
        {
            Q = Q.Replace("\n", " ");
            string newA = "";

            if ( A.Count == 0 ) { return "NULL"; }
            for (int I = 0; I < A.Count; I++ )
            {
                A[I] = A[I].Replace("\n", " "); //how it responds to stuff should not have new lines 
                A[I] = A[I].Replace("|", "-");
                A[I] = A[I].Replace("'", "");
                A[I] = A[I].Replace( ((char)92).ToString(), "/" );
                A[I] = A[I].Replace( ((char)34).ToString(), "");
                A[I] = ARemoveQuoraJargon(A[I]);
                string TempA = A[I];

                if (ATextRemovealIf(A[I]) == true) //true means we can add faulse means WE SHOULD NOT ADD
                {
                    if (TempA.Length >= 1 && TempA.Substring(TempA.Length - 1, 1) == ".")
                    {
                        TempA = TempA.Substring(1, TempA.Length - 1);
                    };
                    TempA = TempA + " |pal:GetEmotiveWord()| user.";
                    newA = newA + (char)34 + A[I] + (char)34 + "," + (char)34 + TempA + (char)34 + ",";
                }
            }

            double[] EmotionLevel = CalulateEmotion( Q+ newA, 0.25 );

            Q = Q.Replace(" ", ","); //turns words to Tags
            Q = QTagSimplfiy(Q);
            Q = QTagRemoval(Q); //removes uneeded Tags
            int[] Block = { 0, ( Q.Split(",").Length -1 ) };
            Q = QToNRTTags(Q, Block );

            if (newA == "") { return "NULL"; }
            return "pal:SetNewInfo( {"+Q+"}, nil, {"+ EmotionLevel[0].ToString()+","+ EmotionLevel[1].ToString()+"}, nil, nil, nil,{"+ newA + "}, nil, nil, nil )";
        }
    }
}
