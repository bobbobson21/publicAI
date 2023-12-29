using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileInterraction
{
    class FileModify //static is love, static is good, static is god
    {

        private static string FilePath = "";
        public static void SetFilePath( string Str ){FilePath = Str;}
        public static string GetFilePath(){return FilePath;}

        public static string CurrentDirectory {get;} = Directory.GetCurrentDirectory();

        public static List<string> GetFileData()
        {
            List<string> Lines = new List<string>();
            try
            {
                StreamReader File = new StreamReader(FilePath);
                string Line = File.ReadLine();

                while (Line != null)
                {
                    Lines.Add(Line);
                    Line = File.ReadLine();
                }

                File.Close();
                return Lines;
            }
            catch
            {
                return Lines;
            }
        }

        public static void SetFileData( List<string> filedata )
        {
            StreamWriter File = new StreamWriter(FilePath);
            foreach (string Line in filedata)
            {
                File.WriteLine( Line );
            }
            File.Close ();
        }

    }

}