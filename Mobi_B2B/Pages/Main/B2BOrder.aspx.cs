using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Pages_Main_B2BOrder : System.Web.UI.Page
{
    private static string ConString = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //init();
        }
    }
    protected void btnStart_Click(object sender, EventArgs e)
    {
        init();
    }
    private void init()
    {
        if (ConString == null)
        {
            ConString = System.Configuration.ConfigurationManager.AppSettings["Dev_WebConnectionString"].ToString();
        }

        MobiPlusWS.MobiPlusWS WR = new MobiPlusWS.MobiPlusWS();
        DataTable dt = WR.B2B_GetSubGroups(ConString);

        StringBuilder sb = new StringBuilder();

        if (tdBead.InnerHtml.Length < 50)
        {
            int LastMainGroup = 0;
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (LastMainGroup != Convert.ToInt32(dt.Rows[i]["MainGroup"]))
                {
                    if (LastMainGroup == 60)
                    {
                        sb.Append("</table></div>");

                        tdMeluchim.InnerHtml = sb.ToString();
                        sb = new StringBuilder();
                    }
                    else if (LastMainGroup == 70)
                    {
                        sb.Append("</table></div>");

                        tdHalav.InnerHtml = sb.ToString();
                        sb = new StringBuilder();
                    }
                    LastMainGroup = Convert.ToInt32(dt.Rows[i]["MainGroup"]);

                    sb.Append("<div class='tblSubGroups' style='height:" + Convert.ToInt64(hdnHeight.Value) / 3.4 + "px'><table cellpadding='0' cellspacing='0'>");

                }

                sb.Append("<tr>");
                sb.Append("<td class='tdCb'>");
                string checked1="";
                string[] arrParams = hdnParams.Value.Split(';');
                for (int y = 0; y < arrParams.Length; y++)
                {
                    if (arrParams[y] != "")
                    {
                        string anaf = arrParams[y].Split('-')[0];
                        string group = arrParams[y].Split('-')[1];
                        if (dt.Rows[i]["MainGroup"].ToString() == anaf && dt.Rows[i]["SubGroup"].ToString() == group)
                        {
                            checked1 = " checked='true' ";
                            break;
                        }
                    }
                }
                
                sb.Append("<input type='checkbox' id='cb" + dt.Rows[i]["SubGroup"].ToString() + "' " + checked1 + " onclick='SetPram(\"" + dt.Rows[i]["MainGroup"].ToString() + "-" + dt.Rows[i]["SubGroup"].ToString() + ";\",this.checked);' class='cb1' name='CbGroup" + LastMainGroup.ToString() + "'/>");
                sb.Append(dt.Rows[i]["SubDescription"].ToString());
                sb.Append("</td>");
                sb.Append("</tr>");


            }


            if (LastMainGroup == 90)
            {
                sb.Append("</table></div>");
                tdBead.InnerHtml = sb.ToString();
            }

            upm.Update();
        }

       
        DataTable dtItems = WR.B2B_GetOrderItems2(hdnParams.Value,ConString);

        sb = new StringBuilder();
        StringBuilder sb2 = new StringBuilder();
        if (Convert.ToInt64(hdnWidth.Value) > 700)
            sb.Append("<center>");
        sb.Append("<table cellpadding='0' cellspacing='0' class='tblAll'>");

        sb.Append("<tr>");
        for (int i = 1; i < dtItems.Rows.Count; i++)
        {
            string ItemName = dtItems.Rows[i]["ItemName"].ToString();
            if (ItemName.Length > 20 && ItemName.IndexOf(" ")==-1)
                ItemName = ItemName.Insert(20, "<br/>");
            sb.Append("<td class='tdItemAll'>");
            sb.Append("<table cellpadding='0' cellspacing='0' width='100%' >");
            sb.Append("<tr>");
            sb.Append("<td class='dtAbTbl'>");
            sb.Append("<table cellpadding='2' cellspacing='2'>");
            sb.Append("<tr>");
            sb.Append("<td class='itemNamer'>");
            sb.Append(ItemName);
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td>");
            sb.Append("במחיר");
            sb.Append("&nbsp;");
            sb.Append("<span class='itemPrice'>");
            sb.Append("₪" + dtItems.Rows[i]["KimPrice"].ToString() + "");
            sb.Append("</span>");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");
            sb.Append("</td>");
            sb.Append("<td class='imgItem' rowspan='2'>");
            sb.Append("<img alt='Mobi B2B' src='../../img/media/pictures/pictures_large/" + dtItems.Rows[i]["ItemCode"].ToString() + ".jpg' class='imgItemN'  onerror=\"if (this.src.indexOf('LogoTnuva.jpg')==-1) {this.src = '../../img/LogoTnuva.jpg'; this.className='imgItemErr';}\"/>");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td class='dohefItem'>");
            sb.Append("&nbsp;");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td colspan='2' class='dtItemFutter'>");
            sb.Append("<table cellpadding='2' cellspacing='2' width='100%'>");
            sb.Append("<tr>");
            sb.Append("<td>");
            sb.Append("בתוקף עד "+DateTime.Now.AddDays(2).Date.ToString("dd.MM.yyyy")+"");
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append("&nbsp;&nbsp;&nbsp;");
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append("<table cellpadding='2' cellspacing='2' width='100%'>");
            sb.Append("<tr>");
            sb.Append("<td>");
            sb.Append("<img alt='Mobi B2B' src='../../img/plus.png' class='plusimg'  onclick='AddUnits(\"" + dtItems.Rows[i]["id"].ToString() + "\");'/>");
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append("<input type='tel' id='txtUnits" + dtItems.Rows[i]["id"].ToString() + "' class='txtUnits' value='0'/>");
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append("<img alt='Mobi B2B' src='../../img/minus.png'  onclick='DelUnits(\"" + dtItems.Rows[i]["id"].ToString() + "\");' class='minusimg'  onerror=\"if (this.src.indexOf('LogoTnuva.jpg')==-1) {this.src = '../../img/LogoTnuva.jpg'; this.className='imgItemErr';}\"/>");
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append("יחידות");
            sb.Append("</td>");
            sb.Append("<td class='imgShoppingCart' id='imgr_" + dtItems.Rows[i]["ItemCode"].ToString() + "' onclick='AddToSal(\"" + dtItems.Rows[i]["ItemCode"].ToString() + "\",\"" + dtItems.Rows[i]["ItemName"].ToString() + "\",\"" + "₪" + dtItems.Rows[i]["KimPrice"].ToString() + "\",$(\"#txtUnits" + dtItems.Rows[i]["id"].ToString() + "\").val(),\"" + dtItems.Rows[i]["id"].ToString() + "\");'>&nbsp;");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");
            sb.Append("</td>");
            
            sb2.Append("setTimeout('SetFieldOnlyNumbers(\"txtUnits" + dtItems.Rows[i]["id"].ToString() + "\");',200);");


            if (Convert.ToInt64(hdnWidth.Value) > 1500)
            {
                if (i % 5 == 0 && i > 1)
                {
                    sb.Append("</tr>");
                    sb.Append("<tr>");
                    sb.Append("<td>");
                    sb.Append("&nbsp;");
                    sb.Append("</td>");
                    sb.Append("</tr>");
                    sb.Append("<tr>");
                }
            }
            else if (Convert.ToInt64(hdnWidth.Value) > 1200)
            {
                if (i % 4 == 0 && i > 1)
                {
                    sb.Append("</tr>");
                    sb.Append("<tr>");
                    sb.Append("<td>");
                    sb.Append("&nbsp;");
                    sb.Append("</td>");
                    sb.Append("</tr>");
                    sb.Append("<tr>");
                }
            }
            else if (Convert.ToInt64(hdnWidth.Value) > 1000)
            {
                if (i % 3 == 0 && i > 1)
                {
                    sb.Append("</tr>");
                    sb.Append("<tr>");
                    sb.Append("<td>");
                    sb.Append("&nbsp;");
                    sb.Append("</td>");
                    sb.Append("</tr>");
                    sb.Append("<tr>");
                }
            }
            else if (Convert.ToInt64(hdnWidth.Value) > 600)
            {
                if (i % 2 == 0 && i > 1)
                {
                    sb.Append("</tr>");
                    sb.Append("<tr>");
                    sb.Append("<td>");
                    sb.Append("&nbsp;");
                    sb.Append("</td>");
                    sb.Append("</tr>");
                    sb.Append("<tr>");
                }
            }
            else 
            {
                if (i % 1 == 0 && i > 0)
                {
                    sb.Append("</tr>");
                    sb.Append("<tr>");
                    sb.Append("<td>");
                    sb.Append("&nbsp;");
                    sb.Append("</td>");
                    sb.Append("</tr>");
                    sb.Append("<tr>");
                }
            }
        }

        sb.Append("</tr></table>");
        if (Convert.ToInt64(hdnWidth.Value) > 700)
            sb.Append("</center>");

        InOrderDataContainer.InnerHtml = sb.ToString();
        InOrderDataContainer.Style["height"] = hdnHeight.Value + "px";
        MainObj.Style["display"]="block";
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShowGrid();", "setTimeout('Show();',100);", true);
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShowGrid1();", sb2.ToString(), true); 
        
    }
}