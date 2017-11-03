using Microsoft.Azure.Mobile.Server;

namespace eXpireService.DataObjects
{
    public class FoodItem : EntityData
    {
        public int FoodItemID { get; set; }

        public string Description { get; set; }

        public FoodType Category { get; set; }

        public int USDACode { get; set; }

        public int DaysToExpire { get; set; }

        public DateTime BoughtDate { get; set; }

        public DateTime? ExpirationDate { get; set; }

        public int SpoonacularID { get; set; }
    }
}