using System.Web.Mvc;

namespace MobiPlus.Layout.WebAPI
{
    public class DefaultController : Controller
    {
        // GET: Default
        public ActionResult Index()
        {
            if (Request.Cookies["lang"] != null)
            {
                var cookievalue = Request.Cookies["lang"].Value;
                if (cookievalue == "he")
                {
                    return View("rtl");
                }
            }
            return View("ltr");

        }
    }
}