using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_MediaEdit : PageBaseCls
{
    private static string MediaSavedImages = "";
    public static string MediaShowImages = "";
    private static string MediaSavedBigImages = "";
    public static string MediaShowBigImages = "";
    public static string MediaSmallImgSizes = "";
    public static string MediaBigImgSizes = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            intConfig();
            if (!IsPostBack)
            {
                init();
                LoadImages(sender, e);
            }
        }
        catch (Exception ex)
        {
            MobiPlusTools.Tools.HandleError(ex, System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString());
            ScriptManager.RegisterClientScriptBlock(this.Page,typeof(Page),"kk"+DateTime.Now.Ticks.ToString(),"alert('אראה שגיאה!');",true);
        }
    }
    protected void DelImg(object sender, EventArgs e)
    {
        String path = MediaSavedBigImages + "\\" + hdnItemID.Value + ".jpg";
        if (System.IO.File.Exists(path)) { System.IO.File.Delete(path); }

        path = MediaSavedImages + "\\" + hdnItemID.Value + ".jpg";
        if (System.IO.File.Exists(path)) { System.IO.File.Delete(path); }

        LoadImages(sender, e);
    }
    protected void UploadImg(object sender, EventArgs e)
    {
        byte[] data = fuMain.FileBytes;
        MemoryStream ms = new MemoryStream(data);
        System.Drawing.Image img = System.Drawing.Image.FromStream(ms); ;
        Bitmap b = null;
        Bitmap bSmall = null;

        if (img.Height > img.Width)
        {
            int def = img.Height / Convert.ToInt32(MediaBigImgSizes.Split(',')[1]);
            if (def == 0)
                def = 1;
            b = ResizeImage(img, img.Width / def, Convert.ToInt32(MediaBigImgSizes.Split(',')[1]));
            def = img.Height / Convert.ToInt32(MediaSmallImgSizes.Split(',')[1]);
            if (def == 0)
                def = 1;
            bSmall = ResizeImage(img, img.Width / def, Convert.ToInt32(MediaSmallImgSizes.Split(',')[1]));
        }
        else
        {
            int def = img.Width / Convert.ToInt32(MediaBigImgSizes.Split(',')[0]);
            if (def == 0)
                def = 1;
            b = ResizeImage(img, Convert.ToInt32(MediaBigImgSizes.Split(',')[0]), img.Height / def);
            def = img.Width / Convert.ToInt32(MediaSmallImgSizes.Split(',')[0]);
            if (def == 0)
                def = 1;
            bSmall = ResizeImage(img, Convert.ToInt32(MediaSmallImgSizes.Split(',')[0]), img.Height / def);
        }
        if (b != null && bSmall != null)
        {
            b.Save(MediaSavedBigImages + "/" + hdnItemID.Value + ".jpg");
            bSmall.Save(MediaSavedImages + "/" + hdnItemID.Value + ".jpg");


            var encoder = ImageCodecInfo.GetImageEncoders()
                            .First(c => c.FormatID == ImageFormat.Jpeg.Guid);
            var encParams = new EncoderParameters(1);
            encParams.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 99L);
            b.Save(MediaSavedBigImages + "/" + hdnItemID.Value + ".jpg", encoder, encParams);
            bSmall.Save(MediaSavedImages + "/" + hdnItemID.Value + ".jpg", encoder, encParams);

            LoadImages(sender,e);
        }
    }
    private void intConfig()
    {
        if (MediaSavedImages == "")
        {
            MediaSavedImages = System.Configuration.ConfigurationManager.AppSettings["MediaSavedImages"].ToString();
        }
        if (MediaShowImages == "")
        {
            MediaShowImages = System.Configuration.ConfigurationManager.AppSettings["MediaShowImages"].ToString();
        }
        if (MediaSavedBigImages == "")
        {
            MediaSavedBigImages = System.Configuration.ConfigurationManager.AppSettings["MediaSavedBigImages"].ToString();
        }
        if (MediaShowBigImages == "")
        {
            MediaShowBigImages = System.Configuration.ConfigurationManager.AppSettings["MediaShowBigImages"].ToString();
        }

        if (MediaSmallImgSizes == "")
        {
            MediaSmallImgSizes = System.Configuration.ConfigurationManager.AppSettings["MediaSmallImgSizes"].ToString();
        }
        if (MediaBigImgSizes == "")
        {
            MediaBigImgSizes = System.Configuration.ConfigurationManager.AppSettings["MediaBigImgSizes"].ToString();
        }
    }

    private void init()
    {
        

        MPLayoutService WR = new MPLayoutService();
        DataTable dt = WR.GetItemFamily(ConStrings.DicAllConStrings[SessionProjectName]);
        FamilyList.DataSource = dt;
        FamilyList.DataValueField = "FamilyId";
        FamilyList.DataTextField = "FamilyName";
        FamilyList.DataBind();
        FamilyList.Focus();

        if (FamilyList.Items.Count > 0)
            FamilyList.SelectedValue = FamilyList.Items[0].Value;
    }

    protected void LoadImages(object sender, EventArgs e)
    {
       
        MPLayoutService WR = new MPLayoutService();
        DataTable dtItems = WR.GetItemsByFamilyID(FamilyList.SelectedValue, ConStrings.DicAllConStrings[SessionProjectName]);

        StringBuilder sb = new StringBuilder();

        if (dtItems != null)
        {
            for (int i = 0; i < dtItems.Rows.Count; i++)
            {
                sb.Append("<div class='BoxImgMedia' onclick='ShowEditImgBox(\""+ dtItems.Rows[i]["ItemId"].ToString() + "\",\"" + dtItems.Rows[i]["ItemName"].ToString().Replace("'","") + "\",\""+DateTime.Now.Ticks.ToString()+"\");'>");
                    sb.Append("<div class='ImgMedia'>");
                        sb.Append("<img height='100px' alt='אין תמונה' class='ImgMediaImg' src='"+ MediaShowImages +"/" + dtItems.Rows[i]["ItemId"].ToString() + ".jpg?T="+DateTime.Now.Ticks.ToString()+"' />");
                    sb.Append("</div>");
                    sb.Append("<div class='dTextImg'>" + dtItems.Rows[i]["ItemId"].ToString() + " - " + dtItems.Rows[i]["ItemName"].ToString());
                    sb.Append("</div>");
                sb.Append("</div>");
            }

            ImgObj.InnerHtml = sb.ToString();
        }

    }
    public static Bitmap ResizeImage(System.Drawing.Image image, int width, int height)
    {
        var destRect = new Rectangle(0, 0, width, height);
        var destImage = new Bitmap(width, height);

        destImage.SetResolution(image.HorizontalResolution, image.VerticalResolution);

        using (var graphics = Graphics.FromImage(destImage))
        {
            graphics.CompositingMode = CompositingMode.SourceCopy;
            graphics.CompositingQuality = CompositingQuality.HighSpeed;
            graphics.InterpolationMode = InterpolationMode.Low;
            graphics.SmoothingMode = SmoothingMode.HighSpeed;
            graphics.PixelOffsetMode = PixelOffsetMode.HighSpeed;

            using (var wrapMode = new ImageAttributes())
            {
                wrapMode.SetWrapMode(WrapMode.TileFlipXY);
                graphics.DrawImage(image, destRect, 0, 0, image.Width, image.Height, GraphicsUnit.Pixel, wrapMode);
            }
        }

        return destImage;
    }
}