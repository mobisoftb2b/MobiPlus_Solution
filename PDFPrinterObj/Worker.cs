using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.IO;
using DAL;
using System.Diagnostics;
using System.Globalization;
using MobiPlusTools;
using System.Threading;
using PDFPrinterObj;

namespace PDFPrinter
{
    public class Worker : PdfPageEventHelper//, System.ServiceProcess.ServiceBase
    {
        public static bool isRunning = true;
        public static string PSDSrc = "";
        public static string LogDir = "";
        public static int LoopSleap = 60000;
        public static string PrinterEXE = "";

        static Font FontText;
        public static void StartWorker()
        {
           

            while (isRunning)
            {
                Tools.AddRowToLog("CreatePDF Start", Worker.LogDir, "PrinterLog");

                CreatePDF();
                
                Tools.AddRowToLog("CreatePDF End", Worker.LogDir, "PrinterLog");

                Thread.Sleep(LoopSleap);
            }
        }

        private static bool PrintDoc()
        {
            try
            {
                Tools.AddRowToLog("Worker.PrinterEXE: "+ Worker.PrinterEXE, Worker.LogDir, "PrinterLog");
                ProcessAsCurrentUser.CreateProcessAsCurrentUser(@Worker.PrinterEXE);//c:\tmp\2.bat

                //System.Diagnostics.Process process = new Process();
                //ProcessStartInfo startInfo = new ProcessStartInfo();
                //startInfo.FileName = @"C:\tmp\pdfPrint.pdf";//@PSDSrc;

                ////assert: can only go to local default printer
                //startInfo.Verb = "Print"; //prints to default printer                   
                //                          //try to keep Window hidden - work in background
                //startInfo.UseShellExecute = true;
                //startInfo.WindowStyle = ProcessWindowStyle.Hidden;
                //startInfo.CreateNoWindow = true;
                //// set process to startInfo and execute start
                //process.StartInfo = startInfo;
                //process.Start();
                //process.WaitForExit(20000);
                //process.CloseMainWindow();
                //process.Close();

                ////Tools.AddRowToLog("Print Start", Worker.LogDir, "PrinterLog");
                ////Process process = new Process();
                ////// Configure the process using the StartInfo properties.
                ////process.StartInfo.FileName = @"C:\tmp\TestPrint\bin\Debug\TestPrint.exe";
                ////process.StartInfo.Arguments = "-n";
                ////process.StartInfo.WindowStyle = ProcessWindowStyle.Maximized;
                ////process.Start();
                ////process.WaitForExit();// Waits here for the process to exit.



                ////System.Diagnostics.Process process = new Process();
                ////ProcessStartInfo startInfo = new ProcessStartInfo();
                ////startInfo.FileName = @"C:\tmp\TestPrint\bin\Debug\TestPrint.exe";//@PSDSrc;

                //////assert: can only go to local default printer
                ////startInfo.Verb = "Print"; //prints to default printer                   
                ////                          //try to keep Window hidden - work in background
                ////startInfo.UseShellExecute = true;
                ////startInfo.WindowStyle = ProcessWindowStyle.Hidden;
                ////startInfo.CreateNoWindow = true;
                ////// set process to startInfo and execute start
                ////process.StartInfo = startInfo;
                ////process.Start();
                ////process.WaitForExit(20000);
                ////process.CloseMainWindow();
                ////process.Close();
                Tools.AddRowToLog("Print End", Worker.LogDir, "PrinterLog");
            }
            catch (Exception ex)
            {
                if (ex.Message != "Process has exited, so the requested information is not available.")
                {
                    Tools.HandleError(ex, LogDir,"","", "PrinterLog");
                    return false;
                }
            }
            return true;
        }

        private static void CreatePDF()
        {
            try
            {
                string WebConnectionString = "";
                if (System.Configuration.ConfigurationSettings.AppSettings["WebConnectionString"].ToString() != "")
                    WebConnectionString = System.Configuration.ConfigurationSettings.AppSettings["WebConnectionString"].ToString();

                string FontSrc = "";
                if (System.Configuration.ConfigurationSettings.AppSettings["FontSrc"].ToString() != "")
                    FontSrc = System.Configuration.ConfigurationSettings.AppSettings["FontSrc"].ToString();


                string HeaderColsSrc = "";
                if (System.Configuration.ConfigurationSettings.AppSettings["HeaderColsSrc"].ToString() != "")
                    HeaderColsSrc = System.Configuration.ConfigurationSettings.AppSettings["HeaderColsSrc"].ToString();

                string HeaderColsShow = "";
                if (System.Configuration.ConfigurationSettings.AppSettings["HeaderColsShow"].ToString() != "")
                    HeaderColsShow = System.Configuration.ConfigurationSettings.AppSettings["HeaderColsShow"].ToString();

                string MainGridWidth = "";
                if (System.Configuration.ConfigurationSettings.AppSettings["MainGridWidth"].ToString() != "")
                    MainGridWidth = System.Configuration.ConfigurationSettings.AppSettings["MainGridWidth"].ToString();

                DataSet ds = DAL.DAL.PDFPrinter_GetData(WebConnectionString);
                DataTable dt;







                BaseFont bfFontTextUniCode = BaseFont.CreateFont(FontSrc, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
                FontText = new Font(bfFontTextUniCode, 12);

                DataTable dtToUpdate = new DataTable();

                for (int u = 0; u < ds.Tables.Count; u = u + 3)
                {
                    FileInfo f = new FileInfo(PSDSrc);
                    if (f.Exists)
                        f.Delete();

                    Document doc = new Document(PageSize.A4);

                    var output = new FileStream(PSDSrc, FileMode.CreateNew);
                    var writer = PdfWriter.GetInstance(doc, output);

                    PageEventHelper pageEventHelper = new PageEventHelper();
                    PageEventHelper.FontText = FontText;
                    writer.PageEvent = pageEventHelper;


                    doc.Open();

                    doc.NewPage();

                    if (ds != null && ds.Tables.Count > 1)
                    {

                        dt = ds.Tables[u + 1];
                        DataTable dtHead = ds.Tables[u];
                        dtToUpdate = ds.Tables[u + 2];

                        string MainCompanySectionAlign = "Right";
                        string HeadLineSectionAlign = "Center";
                        string LeftHeadSectionAlign = "Left";
                        string RightHeadSectionAlign = "Right";
                        string MSGLineSectionAlign = "Right";

                        if (dtHead.Rows.Count > 0)
                        {
                            MainCompanySectionAlign = dtHead.Rows[0]["MainCompanySectionAlign"].ToString();
                            HeadLineSectionAlign = dtHead.Rows[0]["HeadLineSectionAlign"].ToString();
                            LeftHeadSectionAlign = dtHead.Rows[0]["LeftHeadSectionAlign"].ToString();
                            RightHeadSectionAlign = dtHead.Rows[0]["RightHeadSectionAlign"].ToString();
                            MSGLineSectionAlign = dtHead.Rows[0]["MSGLineSectionAlign"].ToString();
                        }
                        int iMainCompanySectionAlign = Element.ALIGN_LEFT;
                        int iHeadLineSectionAlign = Element.ALIGN_CENTER;
                        int iLeftHeadSectionAlign = Element.ALIGN_RIGHT;
                        int iRightHeadSectionAlign = Element.ALIGN_LEFT;
                        int iMSGLineSectionAlign = Element.ALIGN_LEFT;

                        string Align = MainCompanySectionAlign;
                        int iAlign = 0;
                        switch (Align)
                        {
                            case "Left":
                                iAlign = Element.ALIGN_RIGHT;
                                break;
                            case "Center":
                                iAlign = Element.ALIGN_CENTER;
                                break;
                            case "Right":
                                iAlign = Element.ALIGN_LEFT;
                                break;
                        }
                        iMainCompanySectionAlign = iAlign;

                        Align = HeadLineSectionAlign;
                        iAlign = 0;
                        switch (Align)
                        {
                            case "Left":
                                iAlign = Element.ALIGN_RIGHT;
                                break;
                            case "Center":
                                iAlign = Element.ALIGN_CENTER;
                                break;
                            case "Right":
                                iAlign = Element.ALIGN_LEFT;
                                break;
                        }
                        iHeadLineSectionAlign = iAlign;

                        Align = LeftHeadSectionAlign;
                        iAlign = 0;
                        switch (Align)
                        {
                            case "Left":
                                iAlign = Element.ALIGN_RIGHT;
                                break;
                            case "Center":
                                iAlign = Element.ALIGN_CENTER;
                                break;
                            case "Right":
                                iAlign = Element.ALIGN_LEFT;
                                break;
                        }
                        iLeftHeadSectionAlign = iAlign;

                        Align = RightHeadSectionAlign;
                        iAlign = 0;
                        switch (Align)
                        {
                            case "Left":
                                iAlign = Element.ALIGN_RIGHT;
                                break;
                            case "Center":
                                iAlign = Element.ALIGN_CENTER;
                                break;
                            case "Right":
                                iAlign = Element.ALIGN_LEFT;
                                break;
                        }
                        iRightHeadSectionAlign = iAlign;


                        Align = MSGLineSectionAlign;
                        iAlign = 0;
                        switch (Align)
                        {
                            case "Left":
                                iAlign = Element.ALIGN_RIGHT;
                                break;
                            case "Center":
                                iAlign = Element.ALIGN_CENTER;
                                break;
                            case "Right":
                                iAlign = Element.ALIGN_LEFT;
                                break;
                        }
                        iMSGLineSectionAlign = iAlign;


                        //var logo = iTextSharp.text.Image.GetInstance(Server.MapPath("~/ABsIS_Logo.jpg"));
                        //logo.SetAbsolutePosition(430, 770);
                        //logo.ScaleAbsoluteHeight(30);
                        //logo.ScaleAbsoluteWidth(70);
                        //doc.Add(logo);



                        PdfPTable tableDate = new PdfPTable(1);
                        tableDate.DefaultCell.Border = Rectangle.NO_BORDER;

                        tableDate.HorizontalAlignment = iMainCompanySectionAlign;
                        PdfPCell cellDate = new PdfPCell();
                        FontText.SetStyle(dtHead.Rows[0]["MainCompanyStyle"].ToString());
                        Paragraph p = new Paragraph("זמן הדפסה: " + DateTime.Now.ToString("HH:mm:ss dd/MM/yyyy"), FontText);
                        p.SetLeading(1.0f, 1.0f);
                        cellDate.RunDirection = PdfWriter.RUN_DIRECTION_RTL;

                        cellDate.Border = Rectangle.NO_BORDER;
                        p.Alignment = Element.ALIGN_RIGHT;
                        cellDate.AddElement(p);

                        cellDate.HorizontalAlignment = iMainCompanySectionAlign;
                        tableDate.AddCell(cellDate);
                        tableDate.WidthPercentage = 100;
                        doc.Add(tableDate);

                        PdfPTable tableHeader = new PdfPTable(1);
                        tableHeader.DefaultCell.Border = Rectangle.NO_BORDER;

                        tableHeader.HorizontalAlignment = iMainCompanySectionAlign;
                        PdfPCell cellHeader = new PdfPCell();
                        //p = new Paragraph("לכבוד מוביסופט\nגיבורי ישראל 7\nאזור תעשייה ספיר\nנתנייה", FontText);
                        FontText.SetStyle(dtHead.Rows[0]["MainCompanyStyle"].ToString());
                        p = new Paragraph(@dtHead.Rows[0]["MainCompanyData"].ToString().Replace("<BR>", "\n"), FontText);
                        p.SetLeading(1.0f, 1.0f);
                        cellHeader.RunDirection = PdfWriter.RUN_DIRECTION_RTL;

                        cellHeader.Border = Rectangle.NO_BORDER;
                        p.Alignment = iMainCompanySectionAlign;
                        cellHeader.AddElement(p);

                        cellHeader.HorizontalAlignment = iMainCompanySectionAlign;
                        tableHeader.AddCell(cellHeader);
                        tableHeader.WidthPercentage = 100;
                        doc.Add(tableHeader);

                        if (iMainCompanySectionAlign == Element.ALIGN_RIGHT)
                            p.Alignment = Element.ALIGN_LEFT;
                        else if (iMainCompanySectionAlign == Element.ALIGN_LEFT)
                            p.Alignment = Element.ALIGN_RIGHT;
                        else
                            p.Alignment = Element.ALIGN_CENTER;


                        p = new Paragraph(" ", FontText);
                        p.SetLeading(1.0f, 1.0f);
                        doc.Add(p);

                        Font FontTextCust = new Font(bfFontTextUniCode, 12);
                        PdfPTable tableHeaderCust = new PdfPTable(1);
                        tableHeaderCust.DefaultCell.Border = Rectangle.NO_BORDER;

                        tableHeaderCust.HorizontalAlignment = iHeadLineSectionAlign;
                        PdfPCell cellHeaderCust = new PdfPCell();
                        //p = new Paragraph("לכבוד מוביסופט\nגיבורי ישראל 7\nאזור תעשייה ספיר\nנתנייה", FontText);
                        FontTextCust.SetStyle(dtHead.Rows[0]["HeadLineStyle"].ToString());
                        p = new Paragraph(@dtHead.Rows[0]["HeadLine"].ToString().Replace("<BR>", "\n"), FontTextCust);
                        p.SetLeading(1.0f, 1.0f);
                        cellHeaderCust.RunDirection = PdfWriter.RUN_DIRECTION_RTL;

                        cellHeaderCust.Border = Rectangle.NO_BORDER;
                        p.Alignment = iHeadLineSectionAlign;
                        cellHeaderCust.AddElement(p);

                        //cellHeaderCust.HorizontalAlignment = Element.ALIGN_LEFT;
                        tableHeaderCust.AddCell(cellHeaderCust);
                        tableHeaderCust.WidthPercentage = 100;
                        doc.Add(tableHeaderCust);

                        p.Alignment = Element.ALIGN_RIGHT;

                        p = new Paragraph(" ", FontText);
                        p.SetLeading(1.0f, 1.0f);
                        doc.Add(p);



                        Font FontTextLeftCust = new Font(bfFontTextUniCode, 12);
                        PdfPTable tableHeaderLeftCust = new PdfPTable(1);
                        tableHeaderLeftCust.DefaultCell.Border = Rectangle.NO_BORDER;

                        tableHeaderLeftCust.HorizontalAlignment = iLeftHeadSectionAlign;
                        PdfPCell cellHeaderLeftCust = new PdfPCell();
                        FontTextLeftCust.SetStyle(dtHead.Rows[0]["LeftHeadLineStyle"].ToString());
                        p = new Paragraph(@dtHead.Rows[0]["LeftHeadLine"].ToString().Replace("<BR>", "\n"), FontTextLeftCust);
                        p.SetLeading(1.0f, 1.0f);
                        cellHeaderLeftCust.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                        cellHeaderLeftCust.Border = Rectangle.NO_BORDER;
                        p.Alignment = iLeftHeadSectionAlign;
                        cellHeaderLeftCust.AddElement(p);
                        //cellHeaderLeftCust.HorizontalAlignment = Element.ALIGN_LEFT;
                        tableHeaderLeftCust.AddCell(cellHeaderLeftCust);
                        tableHeaderLeftCust.WidthPercentage = 100;
                        doc.Add(tableHeaderLeftCust);

                        //p.Alignment = Element.ALIGN_RIGHT;

                        //p = new Paragraph(" ", FontText);
                        //p.SetLeading(1.0f, 1.0f);
                        //doc.Add(p);

                        //RightHeadLine               
                        Font FontTextRightCust = new Font(bfFontTextUniCode, 12);
                        PdfPTable tableHeaderRightCust = new PdfPTable(1);
                        tableHeaderRightCust.DefaultCell.Border = Rectangle.NO_BORDER;
                        tableHeaderRightCust.HorizontalAlignment = iRightHeadSectionAlign;
                        PdfPCell cellHeaderRightCust = new PdfPCell();
                        FontTextRightCust.SetStyle(dtHead.Rows[0]["RightHeadLineStyle"].ToString());
                        p = new Paragraph(@dtHead.Rows[0]["RightHeadLine"].ToString().Replace("<BR>", "\n"), FontTextRightCust);
                        p.SetLeading(1.0f, 1.0f);
                        cellHeaderRightCust.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                        cellHeaderRightCust.Border = Rectangle.NO_BORDER;
                        p.Alignment = iRightHeadSectionAlign;
                        cellHeaderRightCust.AddElement(p);
                        cellHeaderRightCust.HorizontalAlignment = iRightHeadSectionAlign;
                        tableHeaderRightCust.AddCell(cellHeaderRightCust);
                        tableHeaderRightCust.WidthPercentage = 100;
                        doc.Add(tableHeaderRightCust);

                        p.Alignment = Element.ALIGN_RIGHT;

                        p = new Paragraph(" ", FontText);
                        p.SetLeading(1.0f, 1.0f);
                        doc.Add(p);

                        PdfPTable table1 = new PdfPTable(dt.Columns.Count);
                        table1.DefaultCell.Border = 0;
                        table1.WidthPercentage = 100;
                        MainGridWidth = MainGridWidth.Replace("f", "");
                        string[] arrWidths = MainGridWidth.Split(',');
                        float[] widths = new float[arrWidths.Length];
                        for (int i = 0; i < arrWidths.Length; i++)
                        {
                            widths[i] = float.Parse(arrWidths[i].ToString(), CultureInfo.InvariantCulture.NumberFormat);
                        }
                        table1.SetWidths(widths);

                        Font FontHeader = new Font(bfFontTextUniCode, 12);


                        string[] arrHeaderSrc = HeaderColsSrc.Split(';');
                        string[] arrHeaderColsShow = HeaderColsShow.Split(';');

                        for (int i = arrHeaderColsShow.Length - 1; i >= 0; i--)
                        {
                            PdfPCell cell = new PdfPCell();
                            cell.Colspan = 1;

                            FontHeader.SetStyle("bold");
                            p = new Paragraph(arrHeaderColsShow[i].Trim(), FontHeader);
                            p.Alignment = Element.ALIGN_CENTER;

                            cell.AddElement(p);
                            cell.PaddingBottom = +4f;


                            cell.VerticalAlignment = Element.ALIGN_TOP;
                            cell.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                            table1.AddCell(cell);
                        }
                        doc.Add(table1);
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            table1 = new PdfPTable(arrHeaderSrc.Length);
                            table1.DefaultCell.Border = 0;
                            table1.WidthPercentage = 100;
                            table1.SetWidths(widths);

                            for (int j = arrHeaderSrc.Length - 1; j >= 0; j--)
                            {
                                PdfPCell cell = new PdfPCell();
                                cell.Colspan = 1;

                                p = new Paragraph(dt.Rows[i][arrHeaderSrc[j]].ToString().Trim(), FontText);
                                p.Alignment = Element.ALIGN_LEFT;

                                cell.AddElement(p);
                                cell.PaddingBottom = +4f;

                                cell.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                                cell.VerticalAlignment = Element.ALIGN_TOP;

                                table1.AddCell(cell);
                            }
                            doc.Add(table1);
                        }
                        //הערה
                        //MSGLine,'bold' AS MSGLineStyle,'Right' AS MSGLineSectionAlign
                        PdfPTable tableMSG = new PdfPTable(1);
                        tableMSG.DefaultCell.Border = Rectangle.NO_BORDER;

                        tableMSG.HorizontalAlignment = iMSGLineSectionAlign;
                        PdfPCell cellMSG = new PdfPCell();
                        FontText.SetStyle(dtHead.Rows[0]["MSGLineStyle"].ToString());
                        p = new Paragraph(@dtHead.Rows[0]["MSGLine"].ToString(), FontText);
                        p.SetLeading(1.0f, 1.0f);
                        cellMSG.RunDirection = PdfWriter.RUN_DIRECTION_RTL;

                        cellMSG.Border = Rectangle.NO_BORDER;
                        p.Alignment = Element.ALIGN_LEFT;
                        cellMSG.AddElement(p);

                        cellMSG.HorizontalAlignment = iMSGLineSectionAlign;
                        tableMSG.AddCell(cellMSG);
                        tableMSG.WidthPercentage = 100;
                        doc.Add(tableMSG);



                    }
                    doc.Close();

                    if (PrintDoc())
                    {
                        if (dtToUpdate != null && dtToUpdate.Rows.Count > 0)
                            DAL.DAL.PDFPrinter_SetDocData(dtToUpdate.Rows[0]["DocType"].ToString(), dtToUpdate.Rows[0]["DocNum"].ToString(), dtToUpdate.Rows[0]["Company"].ToString(), dtToUpdate.Rows[0]["AgentId"].ToString(),
                                dtToUpdate.Rows[0]["Cust_Key"].ToString(), dtToUpdate.Rows[0]["DocDate"].ToString(), WebConnectionString);
                    }
                }
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir, "", "", "PrinterLog");
            }
        
        }
        public class PageEventHelper : PdfPageEventHelper
        {
            PdfContentByte cb;
            PdfTemplate template;
            public static Font FontText;
            public override void OnOpenDocument(PdfWriter writer, Document document)
            {
                cb = writer.DirectContent;
                template = cb.CreateTemplate(50, 50);
            }

            public override void OnEndPage(PdfWriter writer, Document document)
            {
                base.OnEndPage(writer, document);

                int pageN = writer.PageNumber;
                String text = "                                                                       Page " + pageN.ToString() + " of ";
                float len = FontText.BaseFont.GetWidthPoint(text, FontText.Size);

                iTextSharp.text.Rectangle pageSize = document.PageSize;

                cb.SetRGBColorFill(100, 100, 100);

                cb.BeginText();
                cb.SetFontAndSize(FontText.BaseFont, FontText.Size);
                cb.SetTextMatrix(document.LeftMargin, pageSize.GetBottom(document.BottomMargin - 20));
                cb.ShowText(text);

                cb.EndText();

                cb.AddTemplate(template, document.LeftMargin + len, pageSize.GetBottom(document.BottomMargin - 20));
            }

            public override void OnCloseDocument(PdfWriter writer, Document document)
            {
                base.OnCloseDocument(writer, document);

                template.BeginText();
                template.SetFontAndSize(FontText.BaseFont, FontText.Size);
                template.SetTextMatrix(0, 0);
                template.ShowText("" + (writer.PageNumber - 1));
                template.EndText();
            }
        }
    }
}
