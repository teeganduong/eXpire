using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.OData;
using Microsoft.Azure.Mobile.Server;
using eXpireService.DataObjects;
using eXpireService.Models;

namespace eXpireService.Controllers
{
    public class FoodItemController : TableController<FoodItem>
    {
        protected override void Initialize(HttpControllerContext controllerContext)
        {
            base.Initialize(controllerContext);
            eXpireContext context = new eXpireContext();
            DomainManager = new EntityDomainManager<FoodItem>(context, Request);
        }

        // GET tables/TodoItem
        public IQueryable<FoodItem> GetAllTodoItems()
        {
            return Query();
        }

        // GET tables/TodoItem/48D68C86-6EA6-4C25-AA33-223FC9A27959
        public SingleResult<FoodItem> GetTodoItem(string id)
        {
            return Lookup(id);
        }

        // PATCH tables/TodoItem/48D68C86-6EA6-4C25-AA33-223FC9A27959
        public Task<FoodItem> PatchTodoItem(string id, Delta<FoodItem> patch)
        {
            return UpdateAsync(id, patch);
        }

        // POST tables/TodoItem
        public async Task<IHttpActionResult> PostTodoItem(FoodItem item)
        {
            FoodItem current = await InsertAsync(item);
            return CreatedAtRoute("Tables", new { id = current.Id }, current);
        }

        // DELETE tables/TodoItem/48D68C86-6EA6-4C25-AA33-223FC9A27959
        public Task DeleteTodoItem(string id)
        {
            return DeleteAsync(id);
        }
    }
}