package expire.expire;

import java.util.Date;

/**
 * Created by mktay on 11/13/2017.
 */

public class FoodItem {

    /**
     * Item text
     */
//    @com.google.gson.annotations.SerializedName("text")
    private String mDescription;

    /**
     * Item Id
     */
    //@com.google.gson.annotations.SerializedName("id")
    private String mId;

    /**
     * Indicates if the item is completed
     */
//    @com.google.gson.annotations.SerializedName("complete")
    private boolean mComplete;

    /**
     * Indicates category of the food (enum value?)
     **/
    private enum Category
    {
        Dairy, Meat, Vegetable, Fruit
    }
    private Category mCategory;

    /*
    * Indicates USDACode
    **/
    private int mUSDACode;

    /*
    * Indicates the number of days that passed before the food expired
    **/
    private int mDaysToExpire;

    /*
    * Indicates bought date
    **/
    private Date mBoughtDate;

    /*
    * Indicates Spoonacular ID
    **/
    private int mSpoonacularId;

    /**
     * FoodItem constructor
     */
    public FoodItem() {

    }

    @Override
    public String toString() {
        return getText();
    }

    /**
     * Initializes a new ToDoItem
     *
     * @param text
     *            The item text
     * @param id
     *            The item id
     */
    public FoodItem(String text, String id) {
        this.setText(text);
        this.setId(id);
    }

    /**
     * Returns the item text
     */
    public String getText() {
        return mDescription;
    }

    /**
     * Sets the item text
     *
     * @param text
     *            text to set
     */
    public final void setText(String text) {
        mDescription = text;
    }

    /**
     * Returns the item id
     */
    public String getId() {
        return mId;
    }

    /**
     * Sets the item id
     *
     * @param id
     *            id to set
     */
    public final void setId(String id) {
        mId = id;
    }

    /**
     * Indicates if the item is marked as completed
     */
    public boolean isComplete() {
        return mComplete;
    }

    /**
     * Marks the item as completed or incompleted
     */
    public void setComplete(boolean complete) {
        mComplete = complete;
    }

    @Override
    public boolean equals(Object o) {
        return o instanceof FoodItem && ((FoodItem) o).mId == mId;
    }
}
