using System;
using System.Text;
using System.Xml;

namespace TextStripInterraction
{
	public class TextStrip
	{
        private static bool LoadedEncodeings = false;
		public static string Strip( string Input )
		{
            if (LoadedEncodeings == false) //has the stuff for conversion been set up
            {
                LoadedEncodeings = true; //THEN SET IT UP FOOL
                CodePagesEncodingProvider.Instance.GetEncoding(437);
                Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            }
            string Output = "";
            
            for (int I = 0; I < Input.Length; I++)
            {
                if (Input.Substring(I, 1) != "�" && (Input.Substring(I, 1) != "?")) //charter is not a broken charter
                {
                    if (Input.Substring(I, 1).All(Str => char.IsLetterOrDigit(Str) || char.IsWhiteSpace(Str))) //charter can be converted to keybord equivalent
                    {
                        byte[] Bytes = Encoding.GetEncoding(437).GetBytes(Input.Substring(I, 1)); //convets the weak one
                        Output = Output + ((char)Bytes[0]).ToString(); //adds coverted symbole to output
                    }
                    else //charter can not be converted, charter may be: {, }, [, ], :, ;, @, ', #, ~, ,, <, ., >, /, |, \, !, ", £, $, %, ^, &, *, (, ), -, _, =, +,
                    {
                        if (Input[I] <= 255 && Input[I] >= 0) //if charater is one of the symboles above add it anyways
                        {
                            Output = Output + Input.Substring(I, 1);
                        } //if not do nothing
                    }
                }
            }
            return Output;
        }
	}
}
