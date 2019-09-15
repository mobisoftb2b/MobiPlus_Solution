using System.Web.Mvc;

namespace Mvc_5_Empty_Template1.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            return View();
        }
    }
}