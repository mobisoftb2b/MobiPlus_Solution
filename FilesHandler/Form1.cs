using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace FilesHandler
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btnStart_Click(object sender, EventArgs e)
        {
            string fileName = txtFile.Text;
            string writeName = txtFile.Text.Substring(0, txtFile.Text.Length - 4) + "_New.txt";

            if (File.Exists(writeName))
                File.Delete(writeName);

            using (FileStream fs = new FileStream(writeName, FileMode.Append, FileAccess.Write))
            using (StreamWriter sw = new StreamWriter(fs))
            {
                var filestream = new System.IO.FileStream(fileName,
                                          System.IO.FileMode.Open,
                                          System.IO.FileAccess.Read,
                                          System.IO.FileShare.ReadWrite);
                using (StreamReader sr = new System.IO.StreamReader(filestream, System.Text.Encoding.GetEncoding(1255), true, 128))
                {
                    string line = String.Empty;

                    while ((line = sr.ReadLine()) != null)
                    {
                        string[] arr = line.Split(';');
                        StringBuilder res = new StringBuilder();
                        for (int i = 0; i < arr.Length; i++)
                        {
                            if (HebHandler.isNumber(arr[i]))
                            {
                                res.Append(arr[i] + ";");
                            }
                            else
                            {
                                res.Append(NBidi.NBidi.LogicalToVisual(arr[i]) + ";");
                            }
                        }
                        sw.WriteLine(res.ToString());
                    }
                }
            }
        }
        private static string GetStr(string strOrg)
        {
            StringBuilder res = new StringBuilder();
            StringBuilder str = new StringBuilder();
            string[] arrString = strOrg.Split(' ');
            for (int t = arrString.Length - 1; t >= 0; t--)
            {
                int[] arrInd = HebHandler.GetNumberIndexes(arrString[t], 0);
                if (arrInd[0] == 0 && arrInd[1] == 0)//not found
                {
                    str.Append(HebHandler.ReverseClearSentence(arrString[t]));
                }
                else if (arrInd[0] == 0)
                {
                    str.Append(arrString[t].Substring(0, arrInd[1]));
                    if (str.Length < strOrg.Length - 1)
                    {
                        res.Append(GetStr(arrString[t].Substring(arrInd[1], arrString[t].Length - arrInd[1])));
                    }
                }
                else
                {
                    str.Append(HebHandler.ReverseClearSentence(arrString[t].Substring(0, arrInd[0])));
                    str.Append(arrString[t].Substring(arrInd[0], arrInd[1] - arrInd[0]));
                    arrInd = HebHandler.GetNumberIndexes(arrString[t], arrInd[1]);

                    if (arrInd[0] == 0 && arrInd[1] == 0)//not found
                    {
                        str.Append(HebHandler.ReverseClearSentence(arrString[t].Substring(str.Length, arrString[t].Length - str.Length)));
                    }
                    else if (arrInd[0] == 0)
                    {
                        str.Append(arrString[t].Substring(arrInd[0], arrString[t].Length - arrInd[1]));
                    }
                    else
                    {

                        str.Append(HebHandler.ReverseClearSentence(arrString[t].Substring(0, arrInd[0] - 1)));
                        str.Append(arrString[t].Substring(arrInd[0], arrString[t].Length - arrInd[1]));

                    }
                }
            }
            str = str.Replace("  ", " ");
            res.Append(str + ";");

            return res.ToString();
        }
    }
}




