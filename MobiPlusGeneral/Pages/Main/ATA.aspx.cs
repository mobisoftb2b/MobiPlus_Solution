using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Main_ATA : System.Web.UI.Page
{
    public string ScriptScr = "";
    public string Road1 = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }

    }
    private void init()
    {
        string myLatlng = ",center: myLatlng0";
        string ScriptScr2 = " var myLatlng0 = new google.maps.LatLng(32.08493, 34.82523); var myLatlng1 = new google.maps.LatLng(32.08991, 34.83921);";
        Road1 = "32.08493, 34.82523, 32.08991, 34.83921";
        //for (int i = 0; i < 2; i++)
        //{


        //    ScriptScr += " var marker" + i.ToString() + " = new google.maps.Marker(" +
        //                                "{ " +
        //                                 "   position: myLatlng" + i.ToString() + ", " +
        //                                 "   map: map, " +
        //                                 "   title: 'tt" + (i + 1).ToString() + "', " +
        //                                 "   icon: '" + i.ToString() + "' == '0' ? '../../img/pin_green.png' : '../../img/pin_red.png' " +
        //                                "}); ";
        //}


        ScriptScr = ScriptScr2 + " var infoWindows = []; var mapOptions = {zoom:15 " + myLatlng + ", mapTypeControlOptions:{mapTypeIds: [google.maps.MapTypeId.ROADMAP, google.maps.MapTypeId.HYBRID,google.maps.MapTypeId.SATELLITE]}};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);" + ScriptScr;
    }


}