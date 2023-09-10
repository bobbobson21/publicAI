using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileInterraction
{
    class FileModify //static is love, static is good, static is god
    {

        private static string filepath = "";
        public static void SetFilePath( string str ){filepath = str;}
        public static string GetFilePath(){return filepath;}

        public static string CurrentDirectory {get;} = Directory.GetCurrentDirectory();

        public static List<string> GetFileData()
        {
            List<string> lines = new List<string>();
            StreamReader file = new StreamReader( filepath );
            string line = file.ReadLine();

            while( line != null)
            {
                lines.Add( line );
                line = file.ReadLine();
            }

            file.Close();
            return lines;
        }

        public static void SetFileData( List<string> filedata )
        {
            StreamWriter file = new StreamWriter(filepath);
            foreach (string line in filedata)
            {
                file.WriteLine( line );
            }
            file.Close ();
        }

    }

}