using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace LayoutManager
{
    public class XMLLayoutHandler
    {
        private static DataTable dt;
        private static int CounterR = 0;
        private static double MaxTabFragmentID = 0;
        private static bool hasVerLay = false;
        private static readonly Object obj = new Object();
        private static double[] arrTopPHeight;
        private static DataTable OrgDT;
        private static int AddCounter = 0;
        private static string colorKey = "A";
        private static int colorCounter = 0;
        private static int counterOO = 0;

        public static bool CreateLayoutXML(string ConnectionString, string TabID, string UserID)
        {
            lock (obj)
            {
                colorCounter = 0;
                counterOO = 0;
                colorKey = "A";
                CounterR = 0;
                MaxTabFragmentID = 0;
                hasVerLay = false;
                StringBuilder sb = new StringBuilder();
                dt = DAL.DAL.LayoutXML_GetDataForXML(ConnectionString, TabID);
                arrTopPHeight = new double[dt.Rows.Count];
                OrgDT = dt;
                int counter = 0;
                double DistinctVal = 0;
                int index = 0;

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (Convert.ToDouble(dt.Rows[i]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[i]["FragmentHeightDP"].ToString()) > DistinctVal + 20)
                    {
                        DistinctVal = Convert.ToDouble(dt.Rows[i]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[i]["FragmentHeightDP"].ToString());
                        arrTopPHeight[index] = DistinctVal;
                        index++;
                    }
                }

                index = 0;
                sb.Append(CreateXML(ConnectionString, TabID, UserID, 0));

                while (OrgDT.Rows.Count > 1 && counter < OrgDT.Rows.Count)
                {
                    index++;

                    counter += CounterR;
                    DataView dv = dt.DefaultView;
                    dv.RowFilter = "TabFragmentID > " + MaxTabFragmentID;

                    dt = dv.ToTable();

                    //counter += CounterR;
                    if (dt.Rows.Count > 0)
                        sb.Append(CreateXML(ConnectionString, TabID, UserID, index));
                    //else
                    //counter = dt.Rows.Count;

                }
                if (OrgDT.Rows.Count > 1)
                    sb.Append("</LinearLayout>");//vertical

                DAL.DAL.LayoutXML_SaveXMLToTab(ConnectionString, TabID, sb.ToString(), UserID);

                return true;
            }
        }
        private static string CreateXML(string ConnectionString, string TabID, string UserID, int index)
        {
            CounterR = 0;
            AddCounter = 0;
            bool isOK = true;
            StringBuilder sbXML = new StringBuilder();
            //sbXML.Append("<gg></gg>");

            switch (colorKey)
            {
                case "A":
                    colorKey = "B";
                    break;
                case "B":
                    colorKey = "C";
                    break;
                case "C":
                    colorKey = "D";
                    break;
                case "D":
                    colorKey = "E";
                    break;
                case "E":
                    colorKey = "F";
                    break;
                case "F":
                    colorKey = "G";
                    break;
                case "G":
                    colorKey = "H";
                    break;
                case "H":
                    colorKey = "I";
                    break;
                case "I":
                    colorKey = "A";
                    break;
            }
            //AddCounter++;


            if (dt != null && dt.Rows.Count > 0)
            {
                double CurrentTop = Convert.ToDouble(dt.Rows[0]["FragmentTop"].ToString());
                double CurrentHeight = Convert.ToDouble(dt.Rows[0]["FragmentHeightDP"].ToString());
                double MaxHeight = Convert.ToDouble(dt.Rows[0]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[0]["FragmentHeightDP"].ToString());
                double MaxObjHeight = Convert.ToDouble(dt.Rows[0]["FragmentHeightDP"].ToString());
                double MinHeight = Convert.ToDouble(dt.Rows[0]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[0]["FragmentHeightDP"].ToString());
                double MinTop = Convert.ToDouble(dt.Rows[0]["FragmentTop"].ToString());
                bool hasVerLayout = false;

                //for (int i = 0; i < dt.Rows.Count; i++)
                int i = 0;
                {

                    //if (dt.Rows.Count == 1) //frame all
                    //{
                    //    AddCounter++;
                    //    if (!hasVerLay)
                    //        sbXML.Append(GetFrameLayout(dt.Rows[i]["FragmentID"].ToString(), "fill_parent", dt.Rows[0]["FragmentHeightDP"].ToString() + "dp", "#CFD1" + colorKey + colorCounter.ToString(), true, true, dt.Rows[i]["LayoutTypeID"].ToString()));
                    //    else
                    //        sbXML.Append(GetFrameLayout(dt.Rows[i]["FragmentID"].ToString(), "fill_parent", dt.Rows[0]["FragmentHeightDP"].ToString() + "dp", "#CFD1" + colorKey + colorCounter.ToString(), false, false, dt.Rows[i]["LayoutTypeID"].ToString()));

                    //    if (Convert.ToDouble(dt.Rows[i]["TabFragmentID"].ToString()) > MaxTabFragmentID)
                    //        MaxTabFragmentID = Convert.ToDouble(dt.Rows[i]["TabFragmentID"].ToString());
                    //}
                    //else
                    {
                        if (!hasVerLay && dt.Rows.Count > 1)
                        {
                            hasVerLay = true;
                            //vertical LinearLayout
                            sbXML.Append("<LinearLayout");
                            sbXML.Append(" android:id=\"@+id/linearlayout_idver\" xmlns:android=\"http://schemas.android.com/apk/res/android\"");
                            sbXML.Append(" android:layout_height=\"fill_parent\"");
                            sbXML.Append(" android:layout_width=\"fill_parent\"");
                            sbXML.Append(" android:orientation=\"vertical\"");
                            sbXML.Append(" android:layout_gravity=\"top\"");
                            sbXML.Append(" android:gravity=\"top\">");
                        }

                        if (dt.Rows.Count > 1)
                            sbXML.Append(" <LinearLayout android:id=\"@+id/ll_selected_id" + i.ToString() + "\"");
                        else
                            sbXML.Append(" <LinearLayout android:id=\"@+id/ll_selected_id" + i.ToString() + "\" xmlns:android=\"http://schemas.android.com/apk/res/android\"");

                        sbXML.Append(" android:layout_width=\"fill_parent\"");
                        sbXML.Append(" android:layout_height=\"wrap_content\"");
                        sbXML.Append(" android:gravity=\"left\"");
                        sbXML.Append(" android:orientation=\"horizontal\">");
                        int lastID = 0;
                        if (CurrentTop == Convert.ToDouble(dt.Rows[0]["FragmentTop"].ToString()))//same row
                        {
                            hasVerLayout = false;
                            if (dt.Rows.Count > 0)
                                lastID = dt.Rows.Count - 1;
                            for (int j = 0; j < dt.Rows.Count; j++)
                            {
                                //lastID = j;
                                if (CurrentTop == Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()))
                                {
                                    if (MaxHeight >= Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString()))
                                    {
                                        MinHeight = Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString());
                                    }
                                    else
                                    {
                                        MaxHeight = Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString());
                                    }
                                    if (MinTop < Convert.ToDouble(dt.Rows[0]["FragmentTop"].ToString()))
                                    {
                                        MinTop = Convert.ToDouble(dt.Rows[0]["FragmentTop"].ToString());
                                    }
                                }
                                else
                                {

                                    break;
                                }
                            }

                            //if (MinHeight == MaxHeight)
                            double maxH = 0;
                            if (CurrentTop == Convert.ToDouble(dt.Rows[0]["FragmentTop"].ToString()) && i + 1 < dt.Rows.Count && Convert.ToDouble(dt.Rows[i]["FragmentHeightDP"].ToString()) == Convert.ToDouble(dt.Rows[i + 1]["FragmentHeightDP"].ToString())) //(CurrentTop == Convert.ToDouble(dt.Rows[0]["FragmentTop"].ToString()) && Convert.ToDouble(dt.Rows[i]["FragmentHeightDP"].ToString()) >= maxH)//same row and same size or larger
                            {

                                for (int j = lastID; j >= 0; j--)
                                {
                                    if (CurrentTop + 10 > Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) && (Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) + 10 < MaxObjHeight + MinTop) && Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString()) >= maxH)
                                    {
                                        switch (colorKey)
                                        {
                                            case "A":
                                                colorKey = "B";
                                                break;
                                            case "B":
                                                colorKey = "C";
                                                break;
                                            case "C":
                                                colorKey = "D";
                                                break;
                                            case "D":
                                                colorKey = "E";
                                                break;
                                            case "E":
                                                colorKey = "F";
                                                break;
                                            case "F":
                                                colorKey = "G";
                                                break;
                                            case "G":
                                                colorKey = "H";
                                                break;
                                            case "H":
                                                colorKey = "I";
                                                break;
                                            case "I":
                                                colorKey = "A";
                                                break;
                                        }
                                        AddCounter++;
                                        sbXML.Append(GetFrameLayout(dt.Rows[j]["FragmentID"].ToString(), dt.Rows[j]["FragmentWidthWeight"].ToString(), dt.Rows[j]["FragmentHeightDP"].ToString() + "dp", "#CFD1" + colorKey + AddCounter.ToString(), false, true, dt.Rows[j]["LayoutTypeID"].ToString()));
                                        if (Convert.ToDouble(dt.Rows[j]["TabFragmentID"].ToString()) > MaxTabFragmentID)
                                            MaxTabFragmentID = Convert.ToDouble(dt.Rows[j]["TabFragmentID"].ToString());
                                        i++;
                                        maxH = Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString());
                                    }
                                    else
                                    {
                                        //i = i + AddCounter;

                                        // break;

                                    }
                                }
                                if (i + 1 < dt.Rows.Count)
                                    CurrentTop = Convert.ToDouble(dt.Rows[i + 1]["FragmentTop"].ToString());
                            }
                            else
                            {
                                for (int j = lastID; j >= 0; j--)
                                {
                                    if (Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString()) + 30 <= CurrentTop + CurrentHeight)
                                    {
                                        if (MaxHeight >= Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString()))
                                        {
                                            MinHeight = Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString());
                                        }
                                        else
                                        {
                                            MaxHeight = Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString());
                                        }

                                        if (MaxObjHeight > Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString()))
                                        {
                                        }
                                        else
                                        {
                                            MaxObjHeight = Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString());
                                        }
                                        if (MinTop < Convert.ToDouble(dt.Rows[0]["FragmentTop"].ToString()))
                                        {
                                            MinTop = Convert.ToDouble(dt.Rows[0]["FragmentTop"].ToString());
                                        }
                                    }
                                }

                                for (int j = lastID; j >= 0; j--)
                                {
                                    if (counterOO > 10)
                                    {
                                        AddCounter = 3000;
                                        break;
                                    }
                                    if (index >= arrTopPHeight.Length)
                                    {
                                        index = arrTopPHeight.Length - 1;
                                        AddCounter--;
                                        counterOO++;
                                    }

                                    if (Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString()) <= arrTopPHeight[index] + 10 && (Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) + 10 < arrTopPHeight[index] + MinTop))
                                    {
                                        //Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString()) == MaxHeight &&

                                        //if (j-1 >=0 && Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString()) + 20 + Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString()) > Convert.ToDouble(dt.Rows[j-1]["FragmentHeightDP"].ToString()) + 20 + Convert.ToDouble(dt.Rows[j-1]["FragmentTop"].ToString()))
                                        if (Convert.ToDouble(dt.Rows[j]["FragmentHeightDP"].ToString()) + 20 >= MaxObjHeight)
                                        {
                                            AddCounter++;
                                            //sbXML.Append("</LinearLayout>");//vertical
                                            sbXML.Append(GetFrameLayout(dt.Rows[j]["FragmentID"].ToString(), dt.Rows[j]["FragmentWidthWeight"].ToString(), dt.Rows[j]["FragmentHeightDP"].ToString() + "dp", "#CFD1" + colorKey + j.ToString(), false, true, dt.Rows[j]["LayoutTypeID"].ToString()));
                                            if (Convert.ToDouble(dt.Rows[j]["TabFragmentID"].ToString()) > MaxTabFragmentID)
                                                MaxTabFragmentID = Convert.ToDouble(dt.Rows[j]["TabFragmentID"].ToString());
                                        }
                                        else
                                        {
                                            bool isInsertVer = false;
                                            CounterR = 0;
                                            for (int r = 0; r <= lastID; r++)
                                            {
                                                if (Convert.ToDouble(dt.Rows[r]["FragmentTop"].ToString()) + Convert.ToDouble(dt.Rows[r]["FragmentHeightDP"].ToString()) <= MaxHeight + 10 && !(Convert.ToDouble(dt.Rows[r]["FragmentHeightDP"].ToString()) == MaxObjHeight) && (Convert.ToDouble(dt.Rows[r]["FragmentTop"].ToString()) + 10 < MaxObjHeight + MinTop))//&& (Convert.ToDouble(dt.Rows[j]["FragmentTop"].ToString())+10 <= MaxObjHeight + MinTop)
                                                {
                                                    isInsertVer = true;
                                                    CounterR++;
                                                    if (!hasVerLayout)
                                                    {
                                                        sbXML.Append(" <LinearLayout");
                                                        sbXML.Append(" android:id=\"@+id/linearlayout_idver" + i.ToString() + "\"");
                                                        sbXML.Append(" android:layout_height=\"fill_parent\"");
                                                        sbXML.Append(" android:layout_width=\"0dp\"");
                                                        sbXML.Append(" android:orientation=\"vertical\"");
                                                        sbXML.Append(" android:layout_gravity=\"top\"");
                                                        sbXML.Append(" android:gravity=\"top\" android:layout_weight=\"" + dt.Rows[j]["FragmentWidthWeight"].ToString() + "\">");
                                                    }

                                                    switch (colorKey)
                                                    {
                                                        case "A":
                                                            colorKey = "B";
                                                            break;
                                                        case "B":
                                                            colorKey = "C";
                                                            break;
                                                        case "C":
                                                            colorKey = "D";
                                                            break;
                                                        case "D":
                                                            colorKey = "E";
                                                            break;
                                                        case "E":
                                                            colorKey = "F";
                                                            break;
                                                        case "F":
                                                            colorKey = "G";
                                                            break;
                                                        case "G":
                                                            colorKey = "H";
                                                            break;
                                                        case "H":
                                                            colorKey = "I";
                                                            break;
                                                        case "I":
                                                            colorKey = "A";
                                                            break;
                                                    }
                                                    AddCounter++;
                                                    sbXML.Append(GetFrameLayout(dt.Rows[r]["FragmentID"].ToString(), "fill_parent", dt.Rows[r]["FragmentHeightDP"].ToString() + "dp", "#CFD1" + colorKey + AddCounter.ToString(), false, false, dt.Rows[r]["LayoutTypeID"].ToString()));
                                                    if (Convert.ToDouble(dt.Rows[r]["TabFragmentID"].ToString()) > MaxTabFragmentID)
                                                        MaxTabFragmentID = Convert.ToDouble(dt.Rows[r]["TabFragmentID"].ToString());

                                                    hasVerLayout = true;
                                                    if (r + 1 == j + 1)
                                                    {
                                                        sbXML.Append("</LinearLayout>");//vertical
                                                    }
                                                }
                                                else
                                                {
                                                    if (isInsertVer && CounterR > 0)
                                                    {
                                                        //j = j - CounterR+1;

                                                        break;
                                                    }
                                                }

                                            }
                                            if (isInsertVer && CounterR > 0)
                                            {

                                                j = j - CounterR + 1;
                                                i = i + CounterR + 1;
                                            }
                                        }

                                    }
                                }
                            }
                        }

                        sbXML.Append("</LinearLayout>");//horizontal
                    }
                    colorCounter++;
                    if (colorCounter > 9)
                        colorCounter = 0;
                }
            }

            CounterR = AddCounter;
            return sbXML.ToString();
        }
        private static string GetFrameLayout(string id, string widthWeight, string height, string BGColor, bool isOnlyOne, bool isToShowWeight,string LayoutTypeID)
        {
            try
            {
                if (LayoutTypeID == "1" || LayoutTypeID == "3")//tablet or web
                    height = (Convert.ToDouble(height.ToLower().Replace("dp", "")) * 1.88).ToString("N0") + "dp";
                else//phone
                    height = (Convert.ToDouble(height.ToLower().Replace("dp", "")) * 1.1).ToString("N0") + "dp";
            }
            catch (Exception ex)
            {
            }

            StringBuilder sbLayout = new StringBuilder();
            if (isOnlyOne)
                sbLayout.Append("<FrameLayout xmlns:android=\"http://schemas.android.com/apk/res/android\"");
            else
                sbLayout.Append("<FrameLayout");

            sbLayout.Append(" android:id=\"@+id/" + id + "\"");

            if (!isOnlyOne)
            {
                if (!isOnlyOne && isToShowWeight)
                    sbLayout.Append(" android:layout_width=\"0dp\"");
                else
                    sbLayout.Append(" android:layout_width=\"" + widthWeight + "\"");
            }
            else
                sbLayout.Append(" android:layout_width=\"fill_parent\"");

            sbLayout.Append(" android:layout_height=\"" + height + "\"");

            if (!isOnlyOne && isToShowWeight)
                sbLayout.Append(" android:layout_weight=\"" + widthWeight + "\"");

            //if (BGColor != string.Empty)
            //    sbLayout.Append(" android:background=\"" + BGColor + "\" >");
            //else
            sbLayout.Append(">");

            sbLayout.Append("</FrameLayout>");

            return sbLayout.ToString();
        }
    }

}

