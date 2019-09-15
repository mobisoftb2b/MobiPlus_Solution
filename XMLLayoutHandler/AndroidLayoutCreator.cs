using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace LayoutManager
{
    public class AndroidLayoutCreator
    {
        private static DataTable dt;
        private static int AddCounter = 0;
        private static string colorKey = "A";
        private static int colorCounter = 0;
        private static int counterOO = 0;

        public static bool CreateLayoutXML(string ConnectionString, string TabID, string UserID)
        {
            StringBuilder sbXML = new StringBuilder();
            dt = DAL.DAL.LayoutXML_GetDataForXML(ConnectionString, TabID);
            bool hasXml = false;

            sbXML.Append("<com.mtn.mobisale.general.ui.Widgets.PercentRelativeLayout");
            if (!hasXml)
                sbXML.Append(" android:id=\"@+id/RelativeLayout_idver007\" xmlns:android=\"http://schemas.android.com/apk/res/android\" xmlns:app=\"http://schemas.android.com/apk/res-auto\"");
            else
                sbXML.Append(" android:id=\"@+id/RelativeLayout_idver007\"");

            hasXml = true;

            sbXML.Append(" android:layout_height=\"fill_parent\"");
            sbXML.Append(" android:layout_width=\"fill_parent\"");
            sbXML.Append(" android:layout_gravity=\"top\"");
            sbXML.Append(" android:gravity=\"top\">");
            double FirstTop = 0;
            double LastTop = 0;
            double mintLeft = 10000;
            int ccounter = 0;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (mintLeft > Convert.ToDouble(dt.Rows[i]["FragmentLeft"].ToString()))
                {
                    mintLeft = Convert.ToDouble(dt.Rows[i]["FragmentLeft"].ToString());
                }
            }
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (i == 0)
                {
                    LastTop = Convert.ToDouble(dt.Rows[i]["FragmentTop"].ToString());
                }

                if (FirstTop == 0)
                {
                    FirstTop = Convert.ToDouble(dt.Rows[i]["FragmentTop"].ToString());

                }

                if(dt.Rows[i]["IsScroll"].ToString()=="1")
                    sbXML.Append("<FrameLayout  android:id=\"@+id/" + dt.Rows[i]["FragmentID"].ToString() + "\" android:layout_width=\"0dp\" app:layout_widthPercent=\"" + ((Convert.ToDouble(dt.Rows[i]["FragmentWidthWeight"].ToString()))).ToString() + "%\"  android:layout_height=\"" + (Convert.ToDouble(dt.Rows[i]["FragmentHeightDP"].ToString()) * 1.9).ToString("N2") + "dp\" app:layout_marginLeftPercent=\"" + (Convert.ToDouble(dt.Rows[i]["FragmentLeftWeight"].ToString())).ToString() + "%\"  android:layout_marginTop=\"" + (((Convert.ToDouble(dt.Rows[i]["FragmentTop"].ToString()) * 1.9 - FirstTop * 1.9))).ToString() + "dp\"></FrameLayout>");//android:background=\"" + "#E2695E" + "\"//+ (ccounter * 5.0 * 1.8)//- (FirstTop+170.0)
                else
                    sbXML.Append("<FrameLayout  android:id=\"@+id/" + dt.Rows[i]["FragmentID"].ToString() + "\" android:layout_width=\"0dp\" app:layout_widthPercent=\"" + ((Convert.ToDouble(dt.Rows[i]["FragmentWidthWeight"].ToString()))).ToString() + "%\" app:layout_heightPercent=\"" + ((Convert.ToDouble(dt.Rows[i]["FragmentHeightWeight"].ToString()))).ToString() + "%\" app:layout_marginLeftPercent=\"" + (Convert.ToDouble(dt.Rows[i]["FragmentLeftWeight"].ToString())).ToString() + "%\" app:layout_marginTopPercent=\"" + dt.Rows[i]["FragmentTopWeight"].ToString() + "%\" ></FrameLayout>");//android:background=\"" + "#E2695E" + "\"//+ (ccounter * 5.0 * 1.8)//- (FirstTop+170.0)

                AddCounter++;

                if (LastTop != Convert.ToDouble(dt.Rows[i]["FragmentTop"].ToString()))
                {
                    LastTop = Convert.ToDouble(dt.Rows[i]["FragmentTop"].ToString());
                    ccounter++;
                }

            }

            sbXML.Append("</com.mtn.mobisale.general.ui.Widgets.PercentRelativeLayout>");

            DAL.DAL.LayoutXML_SavePercentsXMLToTab(ConnectionString, TabID, sbXML.ToString(), UserID);

            return true;
        }

    }
}
