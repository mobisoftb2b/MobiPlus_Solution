using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
//using System.Windows.Forms;
using System.Threading;
using MainService;

public partial class Pages_usr_Default : PageBaseCls
{
    private string[] arrTabs
    {
        get
        {
            if (Session["arrTabs"] == null)
                Session["arrTabs"] = new string[10];
            return (string[])Session["arrTabs"];
        }
        set
        {
            Session["arrTabs"] = value;
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        btnInit.Click+=new EventHandler(btnInit_Click);
        if (!IsPostBack)
        {
            //GetUserWidgets();            
            init();
            //string d=  Request.Url.ToString().Replace("http://" + HttpContext.Current.Request.Url.Host + "/MobiPlusWeb/","");
        }
    }
    protected void btnInit_Click(object sender, EventArgs e)
    {
        if (arrTabs.Length > Convert.ToInt32(hdnTab.Value))
        {
            GetUserWidgets(arrTabs[Convert.ToInt32(hdnTab.Value)]);
        }
        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Tab" + DateTime.Now.Ticks.ToString(), "setTimeout(\"SetTab('" + arrTabs[Convert.ToInt32(hdnTab.Value)] + "');\",5);setTimeout(setTop,1050);", true);
    }
    protected void btnAddTab_Click(object sender, EventArgs e)
    {
        ShowAddTab();
    }
    private void init()
    {


        MobiPlusWS WR = new MobiPlusWS();
        ddlAgents.DataSource = WR.GetAgents(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlAgents.DataTextField = "AgentName";
        ddlAgents.DataValueField = "AgentID";
        ddlAgents.DataBind();

        DataTable dt = WR.GetUserTabs(SessionUserID, ConStrings.DicAllConStrings[SessionProjectName]);
        if (dt != null)
        {
            arrTabs = new string[dt.Rows.Count];
            int i = 0;
            for (i = 0; i < dt.Rows.Count; i++)
            {
                HtmlGenericControl dynLI = new HtmlGenericControl("li");
                HtmlGenericControl dynA = new HtmlGenericControl("a");
                dynA.Attributes["href"] = "#ContentPlaceHolder1_tab" + dt.Rows[i]["TabID"].ToString();
                dynA.Attributes["onclick"] = "setTimeout('MTabClick(\"" + i + "\");',100);setTimeout(initto,100);setTimeout(SetLeftAll,10);";

                dynA.InnerText = dt.Rows[i]["TabName"].ToString();
                //dynA.ID = "a"+dt.Rows[i]["TabID"].ToString();

                dynLI.Controls.Add(dynA);
                tabsUl.Controls.Add(dynLI);

                //GetUserWidgets(dt.Rows[i]["TabID"].ToString());
                arrTabs[i] = dt.Rows[i]["TabID"].ToString();
            }
            if (hdnTab.Value == "" && dt.Rows.Count>0)
                GetUserWidgets(dt.Rows[0]["TabID"].ToString());
            else if (hdnTab.Value != "")
                GetUserWidgets(hdnTab.Value);

            //add tab
            //ShowAddTab();

            HtmlGenericControl dynLI2 = new HtmlGenericControl("li");
            HtmlGenericControl dynA2 = new HtmlGenericControl("a");
            dynA2.Attributes["href"] = "#ContentPlaceHolder1_AddTab";
            dynA2.InnerText = StrSrc("AddTag");//"הוסף תג...";
            dynA2.Attributes["onclick"] = "setTimeout('MTabClick(\"" + (i + 1).ToString() + "\");',100);";

            dynLI2.Controls.Add(dynA2);
            tabsUl.Controls.Add(dynLI2);

            // /addtab


        }
        //dWidgetsList
    }
    private void ShowAddTab()
    {

        HtmlGenericControl dynMainDiv = new HtmlGenericControl("div");
        dynMainDiv.ID = "AddTab";
        dynMainDiv.Style["direction"] = "rtl";
        HtmlGenericControl dynTxt = new HtmlGenericControl("input");
        HtmlGenericControl dynLbl = new HtmlGenericControl("lable");
        HtmlGenericControl dynBtn = new HtmlGenericControl("input");
        dynTxt.Attributes["type"] = "text";
        dynTxt.Attributes["class"] = "txtAdd";
        dynTxt.ID = "txtAddTab";
        dynLbl.InnerText = StrSrc("Tag"); //"תג";
        dynLbl.Attributes["for"] = "ContentPlaceHolder1_txtAddTab";
        dynLbl.Style["padding-left"] = "5px";
        dynBtn.Attributes["type"] = "button";
        dynBtn.Attributes["value"] = StrSrc("Add");//"הוסף";
        dynTxt.Style["padding-left"] = "5px";
        dynBtn.Attributes["onclick"] = "AddTab();";

        dynMainDiv.Controls.Add(dynLbl);
        dynMainDiv.Controls.Add(dynTxt);
        dynMainDiv.Controls.Add(dynBtn);

        dTabs.Controls.Add(dynMainDiv);

        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Tab" + DateTime.Now.Ticks.ToString(), "setTimeout(\"SetFotter();\",5);", true);
    }
    private void GetUserWidgets(string TabID)
    {
        //dTabs.InnerHtml = "";
        dTabs.Controls.Clear();

        if (Session["DocHeight"] == null || (Session["DocHeight"] != null && Convert.ToDouble(Session["DocHeight"]) == 150.0))
        {
            ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Reload" + DateTime.Now.Ticks.ToString(), "DoStart();", true);
            Session["isWinWidth"] = true;
            return;
        }
        Session["isWinWidth"] = false;

        MobiPlusWS WR = new MobiPlusWS();
        DataTable dt = WR.GetUserWidgetsByTabID(SessionUserID, TabID, ConStrings.DicAllConStrings[SessionProjectName]);

        HtmlGenericControl dynMainDiv = new HtmlGenericControl("div");
        dynMainDiv.ID = "tab" + TabID;
        dynMainDiv.Controls.Clear();

        HtmlGenericControl dynMainDiv2 = new HtmlGenericControl("div");
        HtmlGenericControl dynLinkAddWidget1 = new HtmlGenericControl("a");
        dynLinkAddWidget1.Attributes["href"] = "javascript:DeleteTab();";
        dynLinkAddWidget1.Style["height"] = "100%";
        dynLinkAddWidget1.InnerText = StrSrc("DelTag");// "הסר תג";

        dynMainDiv2.Style["text-align"] = "right";

        dynMainDiv2.Controls.Add(dynLinkAddWidget1);
        dynMainDiv.Controls.Add(dynMainDiv2);

        if (dt != null && dt.Rows.Count > 0)
        {



            HtmlGenericControl dynTable = new HtmlGenericControl("table");
            HtmlGenericControl dynTR = new HtmlGenericControl("tr");
            HtmlGenericControl dynTDL = new HtmlGenericControl("td");
            HtmlGenericControl dynTDC = new HtmlGenericControl("td");
            //HtmlGenericControl dynTDR = new HtmlGenericControl("td");

            //dynTable.Style["border"] = "1px solid black";

            dynTable.Attributes["class"] = "tblC";
            dynTable.ID = "tblCC";

            dynTDL.Attributes["class"] = "column l";
            dynTDC.Attributes["class"] = "column c";
            //dynTDR.Attributes["class"] = "column r";

            

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                HtmlGenericControl dynDivHeader = new HtmlGenericControl("div");
                HtmlGenericControl dynDivContent = new HtmlGenericControl("div");
                HtmlGenericControl dynDivPortlet = new HtmlGenericControl("div");

                dynDivHeader.Attributes["class"] = "portlet-header";
                dynDivHeader.InnerText = dt.Rows[i]["name"].ToString();

                dynDivContent.Attributes["class"] = "portlet-content";

                HtmlGenericControl dynIframe = new HtmlGenericControl("IFRAME");
                if (dt.Rows[i]["path"].ToString().IndexOf("?") > -1)
                    dynIframe.Attributes["src"] = dt.Rows[i]["path"].ToString() + "&ID=" + dt.Rows[i]["WidgetsUserID"].ToString();
                else
                    dynIframe.Attributes["src"] = dt.Rows[i]["path"].ToString() + "?ID=" + dt.Rows[i]["WidgetsUserID"].ToString();

                // ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "DoNow", "setTimeout('SetIFRH(\"" + dt.Rows[i]["WidgetsUserID"].ToString() + "\");',50);", true);//DoNow();

                dynIframe.Attributes["class"] = "ifr";
                dynIframe.Attributes["id"] = "ifr" + dt.Rows[i]["WidgetsUserID"].ToString();

                //dynIframe.Attributes["onload"] = "javascript:resizeIframe(this);";

                //dynIframe.Style["height"] = ((Convert.ToDouble(dt.Rows[i]["height"].ToString()) / 100) * Convert.ToDouble(Session["DocHeight"])-150).ToString() + "px";
                //dynIframe.Style["width"] = ((Convert.ToDouble(dt.Rows[i]["width"].ToString()) / 100) * Convert.ToDouble(Session["DocWidth"])).ToString() + "px";//dt.Rows[i]["width"].ToString() + "%";                

                dynDivContent.Controls.Add(dynIframe);

                dynDivPortlet.Controls.Add(dynDivHeader);
                dynDivPortlet.Controls.Add(dynDivContent);

                dynDivPortlet.Style["height"] = ((Convert.ToDouble(dt.Rows[i]["height"].ToString()) / 100) * Convert.ToDouble(Session["DocHeight"])).ToString() + "px";
                dynDivPortlet.Style["width"] = ((Convert.ToDouble(dt.Rows[i]["width"].ToString()) / 100) * Convert.ToDouble(Session["DocWidth"])).ToString() + "px";//dt.Rows[i]["width"].ToString() + "%";                

                dynDivPortlet.Attributes["id"] = dt.Rows[i]["WidgetsUserID"].ToString();


                if (dt.Rows[i]["ColNum"].ToString() == "1")
                {
                    if (dynTDL.Style["width"] == null || (Convert.ToDouble(dynTDL.Style["width"].ToString().Replace("px", "")) < ((Convert.ToDouble(dt.Rows[i]["width"].ToString()) / 100) * Convert.ToDouble(Session["DocWidth"]) + 20)))
                        dynTDL.Style["width"] = ((Convert.ToDouble(dt.Rows[i]["width"].ToString()) / 100) * Convert.ToDouble(Session["DocWidth"]) + 20).ToString() + "px";//dt.Rows[i]["width"].ToString() + "%";

                    dynDivPortlet.Attributes["class"] = "portlet pt1 tdWid";

                    dynDivPortlet.Attributes["class"] = "portlet pt1 tt" + TabID + "_";
                    dynTDL.Controls.Add(dynDivPortlet);
                }

                else if (dt.Rows[i]["ColNum"].ToString() == "2" || dt.Rows[i]["ColNum"].ToString() == "3")
                {
                    if (dynTDC.Style["width"] == null || (Convert.ToDouble(dynTDC.Style["width"].ToString().Replace("px", "")) < ((Convert.ToDouble(dt.Rows[i]["width"].ToString()) / 100) * Convert.ToDouble(Session["DocWidth"]) + 20)))
                        dynTDC.Style["width"] = ((Convert.ToDouble(dt.Rows[i]["width"].ToString()) / 100) * Convert.ToDouble(Session["DocWidth"]) + 20).ToString() + "px";//dt.Rows[i]["width"].ToString() + "%";

                    dynDivPortlet.Attributes["class"] = "portlet pt2";

                    dynDivPortlet.Attributes["class"] = "portlet pt2 tt" + TabID + "_";

                    dynTDC.Controls.Add(dynDivPortlet);
                }

                //if (dt.Rows[i]["ColNum"].ToString() == "3")
                //{
                //    if (dynTDR.Style["width"] == null || (Convert.ToDouble(dynTDR.Style["width"].ToString().Replace("px", "")) < ((Convert.ToDouble(dt.Rows[i]["width"].ToString()) / 100) * Convert.ToDouble(Session["DocWidth"]) + 20)))
                //        dynTDR.Style["width"] = ((Convert.ToDouble(dt.Rows[i]["width"].ToString()) / 100) * Convert.ToDouble(Session["DocWidth"]) + 20).ToString() + "px";//dt.Rows[i]["width"].ToString() + "%";

                //    dynDivPortlet.Attributes["class"] = "portlet pt3";
                //    //if(dt.Rows.Count-1==i)
                //    dynDivPortlet.Attributes["class"] = "portlet pt3 tt" + TabID + "_";


                //    dynTDR.Controls.Add(dynDivPortlet);
                //}
            }

            HtmlGenericControl dyndd = new HtmlGenericControl("div");
            dyndd.InnerHtml = "&nbsp;";
            dyndd.Style["height"] = "30px";

            HtmlGenericControl dyndd2 = new HtmlGenericControl("div");
            dyndd2.InnerHtml = "&nbsp;";
            dyndd2.Style["height"] = "30px";

            dynTDL.Controls.Add(dyndd);
            dynTDC.Controls.Add(dyndd2);

            dynTR.Controls.Add(dynTDL);
            dynTR.Controls.Add(dynTDC);
            //dynTR.Controls.Add(dynTDR);
            dynTable.Controls.Add(dynTR);

            dynMainDiv.Controls.Add(dynTable);
        }
        HtmlGenericControl dynLinkAddWidget = new HtmlGenericControl("a");
        dynLinkAddWidget.Attributes["href"] = "javascript:addWidget();";
        dynLinkAddWidget.Style["height"] = "100%";
        dynLinkAddWidget.InnerText = StrSrc("AddWidget"); //"הוסף דוח";

        dynMainDiv.Controls.Add(dynLinkAddWidget);
        dTabs.Controls.Add(dynMainDiv);

        string TabIDR="1";
        for (int i = 0; i < arrTabs.Length; i++)
        {
            if (arrTabs[i] == TabID)
            {
                TabIDR = i.ToString();
                break;
            }
        }

       //UpdatePaneldTabs.Update();
        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "DoNow" + DateTime.Now.Ticks.ToString(), "setTimeout('DoSortable();',50);setTimeout('SetFotter();',150);setTimeout('SetselectedTab(\"" + TabIDR + "\");',150);setTimeout('SetAllFrames();ShowProperties();',50);", true);//DoNow();

    }
}