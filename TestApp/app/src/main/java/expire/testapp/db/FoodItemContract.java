package expire.testapp.db;

/**
 * Created by Andrew's Computer on 11/15/2017.
 */

import android.provider.BaseColumns;

public class FoodItemContract {
    public static final String DB_NAME = "expire.testapp.db";
    public static final int DB_VERSION = 1;

    public class FoodItemEntry implements BaseColumns {
        public static final String TABLE = "fridge";

        public static final String COL_FOOD_TITLE = "title";
        public static final String COL_FOOD_TYPE = "foodType";
        public static final String COL_QUANTITY = "quantity";
        public static final String COL_EXPIRE_DATE = "expireDate";
        public static final String COL_EXPIRED = "expired";
    }
}
