using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MainService;
using System.Data;
using System.Web.UI.HtmlControls;

public partial class Pages_Admin_AgentsNumerators : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        MobiPlusWS WR = new MobiPlusWS();
        ddlAgents.DataSource = WR.GetAgents(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlAgents.DataTextField = "AgentName";
        ddlAgents.DataValueField = "AgentID";
        ddlAgents.DataBind();

        ddlAgents.Items.Remove(ddlAgents.Items.FindByValue("0"));

        DataTable dt = WR.GetNumeratorsGroups(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dt != null)
        {
            HtmlGenericControl dynTBL = new HtmlGenericControl("table");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                HtmlGenericControl dynTR = new HtmlGenericControl("tr");
                HtmlGenericControl dynTD1 = new HtmlGenericControl("td");
                HtmlGenericControl dynTD2 = new HtmlGenericControl("td");

                dynTD1.InnerText = dt.Rows[i]["NumeratorGroupName"].ToString();

                HtmlGenericControl dynTXT = new HtmlGenericControl("input");
                dynTXT.Attributes["type"] = "text";
                dynTXT.Attributes["class"] = "txtNum";
                dynTXT.ID = "txt1" + dt.Rows[i]["NumeratorGroup"].ToString();
                dynTXT.Attributes["onblur"] = "SetNumerator('" + dt.Rows[i]["NumeratorGroup"].ToString() + "',this.value);";
                dynTD2.Controls.Add(dynTXT);

                dynTD1.Attributes["class"] = "DynRow nTd1";
                dynTD2.Attributes["class"] = "DynRow";

                dynTR.Controls.Add(dynTD1);
                dynTR.Controls.Add(dynTD2);

                dynTBL.Controls.Add(dynTR);

                ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "setNumbers" + i.ToString(), "setTimeout(\"SetFieldOnlyNumbers('ContentPlaceHolder1_" + "txt1" + dt.Rows[i]["NumeratorGroup"].ToString() + "');\",100);", true);
            }
            dTblNtmertors.Controls.Add(dynTBL);
        }
        //dTblNtmertors
    }
}