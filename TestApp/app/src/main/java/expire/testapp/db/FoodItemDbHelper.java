package expire.testapp.db;

/**
 * Created by Andrew's Computer on 11/15/2017.
 */


import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class FoodItemDbHelper extends SQLiteOpenHelper {

    public FoodItemDbHelper(Context context) {
        super(context, FoodItemContract.DB_NAME, null, FoodItemContract.DB_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        String createTable = "CREATE TABLE " + FoodItemContract.FoodItemEntry.TABLE + " ( " +
                FoodItemContract.FoodItemEntry._ID + " INTEGER PRIMARY KEY, " +
                FoodItemContract.FoodItemEntry.COL_FOOD_TITLE + " TEXT, " +
                FoodItemContract.FoodItemEntry.COL_FOOD_TYPE + " TEXT, " +
                FoodItemContract.FoodItemEntry.COL_QUANTITY + " INT, " +
                FoodItemContract.FoodItemEntry.COL_EXPIRE_DATE + " TEXT, " +
                FoodItemContract.FoodItemEntry.COL_EXPIRED + " INT);";

        db.execSQL(createTable);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS " + FoodItemContract.FoodItemEntry.TABLE);
        onCreate(db);
    }
}
