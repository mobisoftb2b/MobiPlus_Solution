using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using MPLayoutService;

public partial class Pages_Compield_CustomersToAgents : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    protected void ddlAgents_SelectedIndexChanged(object sender, EventArgs e)
    {
        //setTbl(ddlAgents.SelectedValue,dTbl,true);
        //UpdatePanelSrc.Update();
    }
    protected void ddlToAgents_SelectedIndexChanged(object sender, EventArgs e)
    {
        //setTbl(ddlToAgents.SelectedValue, dToTbl,false);
        //UpdatePanelTo.Update();
    }
    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        //setTbl(ddlAgents.SelectedValue, dTbl, true);
        //UpdatePanelSrc.Update();

        //setTbl(ddlToAgents.SelectedValue, dToTbl, false);
        //UpdatePanelTo.Update();
    }
    protected void btnMove_Click(object sender, EventArgs e)
    {
        //MoveCustomers();
    }
    private void init()
    {
        MPLayoutService.MPLayoutService WR = new MPLayoutService.MPLayoutService();
        ddlAgents.DataSource = WR.GetAgents(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlAgents.DataTextField = "AgentName";
        ddlAgents.DataValueField = "AgentID";
        ddlAgents.DataBind();
        ListItem item = ddlAgents.SelectedItem;
        item.Text = " בחר ";

        ddlToAgents.DataSource = WR.GetAgents(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlToAgents.DataTextField = "AgentName";
        ddlToAgents.DataValueField = "AgentID";
        ddlToAgents.DataBind();
        item = ddlToAgents.SelectedItem;
        item.Text = " בחר ";
        //ddlAgents.Items.Remove(ddlAgents.Items.FindByValue("0"));
    }
    private void setTbl(string id,HtmlGenericControl div,bool isToShowCB)
    {
        MPLayoutService.MPLayoutService WR = new MPLayoutService.MPLayoutService();
        DataTable dt = null;// WR.GetCustomersForAgent(id);
        if (dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                HtmlGenericControl tblCustomersToAgents = new HtmlGenericControl("table");
                HtmlGenericControl tr = new HtmlGenericControl("tr");
                HtmlGenericControl tdcb = new HtmlGenericControl("td");
                HtmlGenericControl tdname = new HtmlGenericControl("td");
                HtmlGenericControl tddates = new HtmlGenericControl("td");
                HtmlGenericControl cb = new HtmlGenericControl("input");
                cb.Attributes["type"] = "checkbox";

                tdcb.Controls.Add(cb);
                tdname.InnerText = dt.Rows[i]["CustName"].ToString();
                if (!isToShowCB)
                {
                    if (dt.Rows[i]["FromDate"].ToString()!="")
                        tddates.InnerHtml += "<span class='CustDates'>  מתאריך: " + Convert.ToDateTime(dt.Rows[i]["FromDate"].ToString()).ToString("dd/MM/yyyy");
                    if (dt.Rows[i]["ToDate"].ToString()!="")
                        tddates.InnerHtml += "  עד: " + Convert.ToDateTime(dt.Rows[i]["ToDate"].ToString()).ToString("dd/MM/yyyy") + "</span>";
                }
                tdcb.Attributes["class"] = "tblTRCustCB";
                cb.ID = "cb_" + dt.Rows[i]["CustID"].ToString();
                cb.Attributes["class"] = "tblTRCustCB";
                tdname.Attributes["class"] = "tblTRCustName";
                tddates.Attributes["class"] = "tblTRCustDates";
                if (isToShowCB)
                    tr.Controls.Add(tdcb);
                
                tr.Controls.Add(tdname);
                if (!isToShowCB)
                    tr.Controls.Add(tddates);

                tblCustomersToAgents.Attributes["cellpadding"] = "0";
                tblCustomersToAgents.Attributes["cellspacing"] = "0";

                tblCustomersToAgents.Controls.Add(tr);
                div.Controls.Add(tblCustomersToAgents);
            }
            
        }
    }
    private void MoveCustomers()
    {

    }
}