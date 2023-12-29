using FileInterraction;
using TextStripInterraction;
using System.Text;

namespace program
{
    class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine($"starting from:{FileModify.CurrentDirectory}");
            Console.WriteLine("");
            Console.WriteLine("modify file at:"); //hand it the quora info model file
            string InFile = Console.ReadLine();

            FileModify.SetFilePath(InFile);
            List<string> InFileData = FileModify.GetFileData();

            for(int I = 0; I < InFileData.Count; I++)
            {
                InFileData[I] = TextStrip.Strip(InFileData[I]); //removes all emojies and non keybord symboles but will also convert chars like ê this to the keybord equavlent which is e
            }

            FileModify.SetFileData(InFileData);
        }
    }
}