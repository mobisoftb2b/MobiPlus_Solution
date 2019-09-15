using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class tests_cc : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Write("IsAContainsBJumps('dhjkajshd', 'dhj'): " + IsAContainsBJumps("dhjkajshd", "dhj").ToString() + "<br/>");
        Response.Write("IsAContainsBJumps('dhjkajshd', 'dja'): " + IsAContainsBJumps("dhjkajshd", "dja").ToString() + "<br/>");
        Response.Write("IsAContainsBJumps('dhjkajshd', 'kjh'): " + IsAContainsBJumps("dhjkajshd", "kjh").ToString() + "<br/>");
        Response.Write("IsAContainsBJumps('dhjkajshd', 'ks'): " + IsAContainsBJumps("dhjkajshd", "ks").ToString() + "<br/>");
    }
    public bool IsAContainsBJumps(string a, string b)
    {
        int aCounter = 0;
        if (b.Length > 0)
        {
            aCounter = a.IndexOf(b[0]) == -1 ? 0 : a.IndexOf(b[0]);

            for (int i = 0; i < b.Length; i++)
            {
                if ((a[aCounter] != b[i]))
                {
                    return false;
                }
                aCounter += 2;
                if (aCounter + 1 == a.Length)
                    aCounter = 1;
                else if (aCounter + 1 > a.Length)
                    aCounter = 0;
            }
        }
        return true;
    }

}