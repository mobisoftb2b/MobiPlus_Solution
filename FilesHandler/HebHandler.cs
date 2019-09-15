using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace FilesHandler
{
    public class HebHandler
    {
        public static String ToHebPrint(String Str1, bool ToInv) // Hebrew in Dos Structure
        {
            String tempToHebPrint = null;
            // Return Str1
            int I = 0;
            String sTemp = null;
            String sEng = null;
            String sTempLet = null;
            int nAscW = 0;
            tempToHebPrint = Str1;
            sTemp = "";
            I = 0;
            while (I < (Str1 == null ? 0 : Str1.Length))
            {
                sTempLet = Str1.Substring(I, 1);
                Int32.TryParse(sTempLet[0].ToString(), out nAscW);
                if (nAscW >= 1488 && nAscW <= 1514)
                {
                    if (ToInv)
                    {
                        sTemp = (char)(nAscW - 1360) + sTemp;
                    }
                    else
                    {
                        sTemp = sTemp + (char)(nAscW - 1360);
                    }
                    I = I + 1;
                }
                else if (nAscW == 32)
                {
                    if (ToInv)
                    {
                        sTemp = (char)32 + sTemp;
                    }
                    else
                    {
                        sTemp = sTemp + (char)32;
                    }
                    I = I + 1;
                }
                else
                {
                    sEng = "";
                    do
                    {
                        sEng = sEng + sTempLet;
                        I = I + 1;
                        if (I <= (Str1 == null ? 0 : Str1.Length))
                        {
                            if (I < Str1.Length)
                            {
                                sTempLet = Str1.Substring(I, 1);
                               Int32.TryParse(sTempLet[0].ToString(), out nAscW);
                            }
                        }

                    } while (!((nAscW >= 1488 && nAscW <= 1514) || (I >= (Str1 == null ? 0 : Str1.Length) || nAscW == 32)));
                    if (ToInv)
                    {
                        sTemp = sEng + sTemp;
                    }
                    else
                    {
                        sTemp = sTemp + sEng;
                    }
                }
            }
            return sTemp;
        }

        public static String ToHebPDF(String Str1, bool ToInv) // Hebrew in Dos Structure
        {
            String tempToHebPrint = null;
            // Return Str1
            int I = 0;
            String sTemp = null;
            String sEng = null;
            String sTempLet = null;
            int nAscW = 0;
            tempToHebPrint = Str1;
            sTemp = "";
            I = 0;
            while (I < (Str1 == null ? 0 : Str1.Length))
            {
                sTempLet = Str1.Substring(I, 1);
                Int32.TryParse(sTempLet[0].ToString(), out nAscW);
                if (nAscW >= 1488 && nAscW <= 1514)
                {
                    if (ToInv)
                    {
                        sTemp = (char)(nAscW) + sTemp;
                    }
                    else
                    {
                        sTemp = sTemp + (char)(nAscW);
                    }
                    I = I + 1;
                }
                else if (nAscW == 32)
                {
                    if (ToInv)
                    {
                        sTemp = (char)32 + sTemp;
                    }
                    else
                    {
                        sTemp = sTemp + (char)32;
                    }
                    I = I + 1;
                }
                else
                {
                    sEng = "";
                    do
                    {
                        sEng = sEng + sTempLet;
                        I = I + 1;
                        if (I <= (Str1 == null ? 0 : Str1.Length))
                        {
                            if (I < Str1.Length)
                            {
                                sTempLet = Str1.Substring(I, 1);
                                Int32.TryParse(sTempLet[0].ToString(), out nAscW);
                            }
                        }

                    } while (!((nAscW >= 1488 && nAscW <= 1514) || (I >= (Str1 == null ? 0 : Str1.Length) || nAscW == 32)));
                    if (ToInv)
                    {
                        sTemp = sEng + sTemp;
                    }
                    else
                    {
                        sTemp = sTemp + sEng;
                    }
                }
            }
            return sTemp;
        }

        public static String ReverseString(String str)
        {
            str = str.Replace(",", "");
            String Res = "";

            for (int i = str.Length - 1; i >= 0; i--)
            {
                if (isNumber(str))
                {
                    for (int j = 0; j < i + 1; j++)
                    {
                        if (Char.IsDigit(str[j]))
                        {
                            Res += str[j];
                            if (j == i)
                            {
                                i = i - j;
                                break;
                            }
                        }
                        else
                        {
                            i = i - j;
                            break;
                        }
                    }
                }
                else
                {
                    if (str[i] == ')')
                        Res += "(";
                    else if (str[i] == '(')
                        Res += ")";
                    else if (str[i] == '}')
                        Res += "{";
                    else if (str[i] == '{')
                        Res += "}";
                    else if (Char.IsDigit(str[i]) && i + 1 <= str.Length - 1 && !Char.IsDigit(str[i + 1]))
                    {
                        Res = Res + " " + str.Substring(0,i);
                        break;
                    }
                    else if (Char.IsDigit(str[i]))
                    {
                        int counter = 0;
                        int index = i;
                        for (int j = 0; j < index + 1; j++)
                        {
                            if (Char.IsDigit(str[j]))
                            {
                                if (i > 0 || str[j] == str[i])
                                {
                                    Res += str[j];
                                    //i++;
                                }
                                if ((j + 1 >= index + 1 || !Char.IsDigit(str[j+1])) && j > 0)
                                    break;
                                counter++;
                                if (j == i)
                                {
                                    if (counter > 1)
                                        i = i - counter;
                                    break;
                                }
                            }
                            else
                            {
                                if (str[j] == '/' || str[i] == '-')
                                    Res += str[i];
                                else if (str[i] == '(')
                                {
                                    Res += ")";
                                    break;
                                }
                                else if (str[i] == ')')
                                {
                                    Res += "(";
                                    break;
                                }
                                else if (str[i] == '{')
                                {
                                    Res += "}";
                                    break;
                                }
                                else if (str[j] == '}')
                                {
                                    Res += "{";
                                    break;
                                }
                            }
                        }
                    }
                    else
                        Res += str[i];
                }
            }
            Res = Res.Replace("()", "").Replace("((", "(").Replace("))", ")");
            if (isNumber(str))
            {
                if (Res.Length > 0)
                {
                    //DecimalFormat df = new DecimalFormat("#,###.##");
                    //Res =df.format(Double.parseDouble(Res)).toString();
                }
            }
            return Res;
        }
        public static int[] GetNumberIndexes(string str,int startFrom)
        {
            int[] res = new int[2];

            bool FoundNumber = false;
            for (int i = startFrom; i < str.Length; i++)
            {
                if (str[i].ToString() != "." && isNumber(str[i].ToString()) & !FoundNumber)
                {
                    res[0] = i;
                    FoundNumber = true;
                }
                else if (FoundNumber && !isNumber(str[i].ToString()))
                {
                    res[1] = i;
                    break;
                }
            }

            return res;
        }
        public static bool isNumber(String str)
        {
            for (int i = 0; i < str.Length; i++)
            {
                if (str[i] != '.' && Char.IsDigit(str[i]) == false)
                    return false;
            }
            return true;
        }

        private static bool isEngilish(String str)
        {
            try
            {
                for (int i = 0; i < str.Length; i++)
                {
                    if (!(((int)str[i] > 63 && (int)str[i] < 133) || ((int)str[i] > 96 && (int)str[i] < 123)))
                        return false;
                }

            }
            catch (Exception e)
            {
            }
            return true;
        }
        private static String CheckAndRemoveAsciKeyEnglish(String str)
        {
            String RealStr = "";
            for (int i = 0; i < str.Length; i++)
            {
                if ((int)str[i] == 125 || (int)str[i] == 123 || (int)str[i] == 34 || (int)str[i] == 44 || (int)str[i] == 46 || (int)str[i] == 47 || (int)str[i] == 92 || (int)str[i] == 32 || (int)str[i] == 40 || (int)str[i] == 41 || (int)str[i] == 45 || ((int)(str[i]) >= 48 && ((int)str[i]) <= 58)
                    || ((int)str[i] > 1485 && (int)str[i] < 1515) || ((int)str[i] > 63 && (int)str[i] < 133) || ((int)str[i] > 96 && (int)str[i] < 123))
                    RealStr += str[i];
            }
            return RealStr;
        }

        public static String ReverseClearSentence(String str)
        {
            String Res = "";
            str = str.Replace("\n", "");
            String[] arrStr;

            //str = str.Replace("{", " &(& ");
            //str = str.Replace("}", " &)& ");
            //str = str.Replace("(", " %(% ");
            //str = str.Replace(")", " %)% ");
            //str = str.Replace("-", " * ");
            //str = str.Replace(":", " : ");
            //str = str.Replace("(", " ^( ");
            //str = str.Replace("&", " & ");

            arrStr = str.Split(' ');
            //if (arrStr.Length == 2)
            //{
            //    if (!isNumber(arrStr[0]) && isNumber(arrStr[1]))
            //        return str;
            //}
            for (int i = arrStr.Length - 1; i >= 0; i--)
            {
                if (isEngilish(arrStr[i]))
                    Res += arrStr[i];
                else
                {
                    String stra = arrStr[i];

                    String[] arr = stra.Replace("\n", "").Split('.');
                    for (int y = 0; y < arr.Length; y++)
                    {
                        Res += ReverseString(arr[y].Replace("\n", ""));
                        if (y == 0 && arr.Length > 1)
                            Res += ".";
                    }
                }
                if (str.IndexOf(" ")>-1)
                    Res += " ";
            }
            //Res = Res.Replace("*", "-");
            //Res = Res.Replace("^ ", "");
            //Res = Res.Replace(" )", ")");
            //Res = Res.Replace(")(", ") (");
            //Res = Res.Replace(" %(% ", "(");
            //Res = Res.Replace(" %)% ", ")");
            //Res = Res.Replace(" &(& ", "{");
            //Res = Res.Replace(" &)& ", "}");
            //Res = Res.Replace(" & ", "&");


            return Res;//+ "\n"
        }
        public static string ReverseStringNew(string str)
        {
            StringBuilder res = new StringBuilder();

            for (int i = str.Length-1; i >=0; i--)
            {
                res.Append(str[i]);
            }

            return res.ToString();
        }

    }
}
