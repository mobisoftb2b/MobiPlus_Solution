using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;

public partial class Pages_Compield_Routes : PageBaseCls
{
    public string Cust_Key = "";
    public string CustName = "";
    public string Lang = "";
    public int NumberOfWeeks = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;
        if (!IsPostBack)
        {
            if (Request.QueryString["Cust_Key"] != null)
                Cust_Key = Request.QueryString["Cust_Key"];
            if (Request.QueryString["CustName"] != null)
                CustName = Request.QueryString["CustName"];
            init();
            bildCyclicRoutes();
        }
    }
    private void init()
    {
        DataSet ds = new DataSet();
        MPLayoutService WR = new MPLayoutService();
        ds = WR.MPLayout_GetRoutes(Cust_Key, ConStrings.DicAllConStrings[SessionProjectName]);
        if (ds != null && ds.Tables.Count > 1)
        {
            DataTable dtDaily = ds.Tables[0];
            DataTable dtByDate = ds.Tables[1];
            DataTable dtWeekly = ds.Tables[2];
            DataTable dtCyclic = ds.Tables[3];

            if (dtDaily != null && dtDaily.Rows.Count > 0)
            {
                if (dtDaily.Rows[0]["Interval"].ToString() != null)
                {
                    //DateTime dateFromD = Convert.ToDateTime(dtDaily.Rows[0]["FromDate"].ToString());
                    //string sDateFromD = dateFromD.ToString("dd/MM/yyyy");
                    //DateTime dateToD = Convert.ToDateTime(dtDaily.Rows[0]["ToDate"].ToString());
                    //string sDateToD = dateToD.ToString("dd/MM/yyyy");

                    hdnDaily.Value = dtDaily.Rows[0]["Interval"].ToString();
                    //hdnDaily.Value += ";" + sDateFromD;
                    //hdnDaily.Value += ";" + sDateToD;
                    hdnDaily.Value += ";" + dtDaily.Rows[0]["FromTime"].ToString().Substring(11, 5);
                    hdnDaily.Value += ";" + dtDaily.Rows[0]["ToTime"].ToString().Substring(11, 5);
                }
            }
            if (dtByDate != null && dtByDate.Rows.Count > 0)
            {
                if (dtByDate.Rows[0]["Date"].ToString() != null)
                {
                    for (int i = 0; i < dtByDate.Rows.Count; i++)
                    {

                        DateTime date = Convert.ToDateTime(dtByDate.Rows[i]["Date"].ToString());
                        string sDate = date.ToString("dd/MM/yyyy");
                        if (i == 0)
                            hdnByDate.Value += dtByDate.Rows[i]["FromTime"].ToString().Substring(11, 5);
                        else
                            hdnByDate.Value += ";" + dtByDate.Rows[i]["FromTime"].ToString().Substring(11, 5);
                        hdnByDate.Value += " " + dtByDate.Rows[i]["ToTime"].ToString().Substring(11, 5);
                        hdnByDate.Value += " " + sDate;
                    }
                }
            }
            if (dtWeekly != null && dtWeekly.Rows.Count > 0)
            {
                if (dtWeekly.Rows[0]["DayOfWeek"].ToString() != null)
                {

                    //DateTime dateFromW = Convert.ToDateTime(dtWeekly.Rows[0]["FromDate"].ToString());
                    //string sDateFromW = dateFromW.ToString("dd/MM/yyyy");
                    //DateTime dateToW = Convert.ToDateTime(dtWeekly.Rows[0]["ToDate"].ToString());
                    //string sDateToW = dateToW.ToString("dd/MM/yyyy");
                    //hdnWeekly.Value = sDateFromW;
                    //hdnWeekly.Value += ";" + sDateToW;
                    bool first = true;
                    for (int i = 0; i < dtWeekly.Rows.Count; i++)
                    {
                        if (first)
                        {
                            hdnWeekly.Value += dtWeekly.Rows[i]["DayOfWeek"].ToString();
                            first = false;
                        }
                        else
                        {
                            hdnWeekly.Value += ";" + dtWeekly.Rows[i]["DayOfWeek"].ToString();
                        }

                        hdnWeekly.Value += ";" + dtWeekly.Rows[i]["FromTime"].ToString().Substring(11, 5);
                        hdnWeekly.Value += ";" + dtWeekly.Rows[i]["ToTime"].ToString().Substring(11, 5);
                    }
                }
            }
            if (dtCyclic != null && dtCyclic.Rows.Count > 0)
            {
                if (dtCyclic.Rows[0]["WeekNumber"].ToString() != null)
                {

                    //DateTime dateFromC = Convert.ToDateTime(dtCyclic.Rows[0]["FromDate"].ToString());
                    //string sDateFromC = dateFromC.ToString("dd/MM/yyyy");
                    //DateTime dateToC = Convert.ToDateTime(dtCyclic.Rows[0]["ToDate"].ToString());
                    //string sDateToC = dateToC.ToString("dd/MM/yyyy");
                    //hdnCyclic.Value = sDateFromC;
                    //hdnCyclic.Value += ";" + sDateToC;
                    bool first = true;
                    for (int i = 0; i < dtCyclic.Rows.Count; i++)
                    {
                        int week = Convert.ToInt32(dtCyclic.Rows[i]["WeekNumber"]);
                        int day = Convert.ToInt32(dtCyclic.Rows[i]["DayOfWeek"]);
                        if (first)
                        {
                            hdnCyclic.Value += ((week - 1) * 7 + day).ToString();
                            first = false;
                        }
                        else
                        {
                            hdnCyclic.Value += ";" + ((week - 1) * 7 + day).ToString();
                        }

                        hdnCyclic.Value += ";" + dtCyclic.Rows[i]["FromTime"].ToString().Substring(11, 5);
                        hdnCyclic.Value += ";" + dtCyclic.Rows[i]["ToTime"].ToString().Substring(11, 5);
                    }
                }
            }
        }
    }
    private void bildCyclicRoutes()
    {
        MPLayoutService wr = new MPLayoutService();
        DataTable dt = new DataTable();
        dt = wr.MPLayout_RoutesGetSettings(ConStrings.DicAllConStrings[SessionProjectName]);
        
        NumberOfWeeks =Convert.ToInt32( dt.Rows[0]["NumberOfWeeksToCyclic"]);

        HtmlGenericControl Tbl = new HtmlGenericControl("table");
        Tbl.Attributes["cellpadding"] = "1";
        Tbl.Attributes["cellspacing"] = "1";
        Tbl.Attributes["class"] = "SectionWidjet";



        for (int i = 0; i < NumberOfWeeks+1; i++)
        {
            HtmlGenericControl tr = new HtmlGenericControl("tr");

            if (i == 0)
            {
                for (int j = 0; j < 8; j++)
                {
                    HtmlGenericControl td = new HtmlGenericControl("td");

                    switch (j)
                    {
                        case 0:
                            td.Attributes["class"] = "SideRouteDays";
                            td.InnerText = "#";
                            break;
                        case 1:
                            td.Attributes["class"] = "RouteDays";
                            td.InnerText = StrSrc("Sunday");
                            break;
                        case 2:
                            td.Attributes["class"] = "RouteDays";
                            td.InnerText = StrSrc("Monday");
                            break;
                        case 3:
                            td.Attributes["class"] = "RouteDays";
                            td.InnerText = StrSrc("Tuesday");
                            break;
                        case 4:
                            td.Attributes["class"] = "RouteDays";
                            td.InnerText = StrSrc("Wednesday");
                            break;
                        case 5:
                            td.Attributes["class"] = "RouteDays";
                            td.InnerText = StrSrc("Thursday");
                            break;
                        case 6:
                            td.Attributes["class"] = "RouteDays";
                            td.InnerText = StrSrc("Friday");
                            break;
                        case 7:
                            td.Attributes["class"] = "RouteDays";
                            td.InnerText = StrSrc("Saturday");
                            break;
                    }
                    tr.Controls.Add(td);
                }
            }
            else
            {
                for (int j = 0; j < 8; j++)
                {
                    HtmlGenericControl td = new HtmlGenericControl("td");
                    if (j == 0)
                    {
                        td.Attributes["class"] = "SideRouteDays";
                        td.InnerText = i.ToString();
                    }
                    else
                    {
                        td.Attributes["class"] = "tdDay";
                        HtmlGenericControl dayDiv = new HtmlGenericControl("div");
                        dayDiv.Attributes["class"] = "day-content";
                        HtmlGenericControl dayTable = new HtmlGenericControl("table");
                        HtmlGenericControl dayTr = new HtmlGenericControl("tr");
                        HtmlGenericControl dayTd = new HtmlGenericControl("td");
                        dayTd.Attributes["rowspan"] = "2";
                        HtmlGenericControl RouteDaySelectDiv = new HtmlGenericControl("div");
                        int num = ((i - 1) * 7 + j);
                        string Snum = num.ToString();
                        if (num < 10) { Snum = "0" + Snum; }
                        RouteDaySelectDiv.ID = "Cday" + Snum;
                        RouteDaySelectDiv.Attributes["class"] = "Cday" + Snum + " RouteDayNotSelected";
                        RouteDaySelectDiv.Attributes["onclick"] = "SetRoutesSelected('" + "Cday" + Snum + "');";
                        dayTd.Controls.Add(RouteDaySelectDiv);
                        dayTr.Controls.Add(dayTd);
                        HtmlGenericControl dayTd2 = new HtmlGenericControl("td");
                        HtmlGenericControl RouteTimeDiv = new HtmlGenericControl("div");
                        //  <div class="RouteTimeCday01" onclick="OpenTimeDiv('C','01');">
                        RouteTimeDiv.Attributes["class"] = "RouteTime RouteTimeCday" + Snum;
                        RouteTimeDiv.Attributes["onclick"] = "OpenTimeDiv('C','" + Snum + "');";
                        
                        HtmlGenericControl RouteTimeTable = new HtmlGenericControl("table");
                        HtmlGenericControl RouteTimeTr = new HtmlGenericControl("tr");
                        HtmlGenericControl RouteFTimeTd1 = new HtmlGenericControl("td");
                        HtmlGenericControl RouteFTimeTd2 = new HtmlGenericControl("td");
                        HtmlGenericControl RouteTimeTr2 = new HtmlGenericControl("tr");
                        HtmlGenericControl RouteTTimeTd1 = new HtmlGenericControl("td");
                        HtmlGenericControl RouteTTimeTd2 = new HtmlGenericControl("td");
                        // < table >
                        //                                                               <tr>
                        //                                                                   <td><%=StrSrc("S")%>
                        //                                                                   </td>
                        //                                                                   <td>
                        //                                                                       <input id = "txtFTimeCDay01" type="text" readonly="true" class="txtTime FromTime" />
                        //                                                                   </td>
                        //                                                               </tr>
                        RouteFTimeTd1.InnerText = StrSrc("S");
                        RouteTimeTr.Controls.Add(RouteFTimeTd1);
                        HtmlGenericControl RouteTimeinput1 = new HtmlGenericControl("input");
                        RouteTimeinput1.ID= "txtFTimeCDay" + Snum;
                        RouteTimeinput1.Attributes["class"] = "txtTime FromTime";
                        RouteTimeinput1.Attributes["type"] = "text";
                        RouteTimeinput1.Attributes["readonly"] = "true";
                        RouteFTimeTd2.Controls.Add(RouteTimeinput1);
                        RouteTimeTr.Controls.Add(RouteFTimeTd2);
                        RouteTimeTable.Controls.Add(RouteTimeTr);
                        //                                                               <tr>
                        //                                                                   <td><%=StrSrc("E")%>  
                        //                                                                   </td>
                        //                                                                   <td>
                        //                                                                       <input id = "txtTTimeCDay01" type="text" readonly="true" class="txtTime ToTime" />
                        //                                                                   </td>
                        //                                                               </tr>
                        //                                                           </table>
                        RouteTTimeTd1.InnerText = StrSrc("E");
                        RouteTimeTr2.Controls.Add(RouteTTimeTd1);
                        HtmlGenericControl RouteTimeinput2 = new HtmlGenericControl("input");
                        RouteTimeinput2.ID = "txtTTimeCDay" + Snum;
                        RouteTimeinput2.Attributes["class"] = "txtTime ToTime";
                        RouteTimeinput2.Attributes["type"] = "text";
                        RouteTimeinput2.Attributes["readonly"] = "true";
                        RouteTTimeTd2.Controls.Add(RouteTimeinput2);
                        RouteTimeTr2.Controls.Add(RouteTTimeTd2);
                        RouteTimeTable.Controls.Add(RouteTimeTr2);



                        RouteTimeDiv.Controls.Add(RouteTimeTable);
                        dayTd2.Controls.Add(RouteTimeDiv);
                        dayTr.Controls.Add(dayTd2);
                        dayTable.Controls.Add(dayTr);
                        dayDiv.Controls.Add(dayTable);
                        td.Controls.Add(dayDiv);
                    }
                    tr.Controls.Add(td);
                }
              
            }
            Tbl.Controls.Add(tr);
        }

          CyclicRoutes.Controls.Add(Tbl);
    }
}