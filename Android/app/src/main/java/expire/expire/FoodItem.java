package expire.expire;

//import com.google.gson.annotations.SerializedName;
import java.util.Date;

/**
 * Created by mktaylor on 11/13/2017.
 */

public class FoodItem {

    //@com.google.gson.annotations.SerializedName("description")
    private String mDescription;
    public String getDescription() {
        return mDescription;
    }
    public final void setDescription(String description) {
        mDescription = description;
    }

    //@com.google.gson.annotations.SerializedName("id")
    private String mId;
    public String getId() {
        return mId;
    }
    public final void setId(String id) {
        mId = id;
    }

    private enum Category
    {
        Dairy, Meat, Vegetable, Fruit
    }
    //@com.google.gson.annotations.SerializedName("category")
    private Category mCategory;
    public Category getCategory() {
        return mCategory;
    }
    public final void setDescription(Category category) {
        mCategory = category;
    }

    //@com.google.gson.annotations.SerializedName("usdacode")
    private int mUSDACode;
    public int getUSDACode() {
        return mUSDACode;
    }
    public final void setId(int USDACode) {
        mUSDACode = USDACode;
    }

    //@com.google.gson.annotations.SerializedName("daystoexpire")
    private int mDaysToExpire;
    public int getDaysToExpire() {
        return mDaysToExpire;
    }
    public final void setDaysToExpire(int DaysToExpire) {
        mDaysToExpire = DaysToExpire;
    }

    //@com.google.gson.annotations.SerializedName("boughtdate")
    private Date mBoughtDate;
    public Date getBoughtDate() {
        return mBoughtDate;
    }
    public final void setBoughtDate(Date BoughtDate) {
        mBoughtDate = BoughtDate;
    }

    //@com.google.gson.annotations.SerializedName("spoonacularid")
    private int mSpoonacularId;
    public int getSpoonacularId(){ return mSpoonacularId; }
    public final void setmSpoonacularId(int SpoonacularId) { mSpoonacularId = SpoonacularId; }


    public FoodItem() {

    }

    public FoodItem(String description, String id) {
        this.setDescription(description);
        this.setId(id);
    }


    @Override
    public String toString() {
        return getDescription();
    }

    @Override
    public boolean equals(Object o) {
        return o instanceof FoodItem && ((FoodItem) o).mId == mId;
    }
}
