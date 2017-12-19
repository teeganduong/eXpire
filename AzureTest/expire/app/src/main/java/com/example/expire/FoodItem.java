package com.example.expire;

import java.util.Date;

/**
 * Created by mktay on 11/29/2017.
 */

public class FoodItem {

    @com.google.gson.annotations.SerializedName("description")
    private String mText;

    @com.google.gson.annotations.SerializedName("id")
    private String mId;

    @com.google.gson.annotations.SerializedName("deleted")
    private boolean mComplete;

    @com.google.gson.annotations.SerializedName("added")
    private Date mDateAdded;

    @com.google.gson.annotations.SerializedName("expired")
    private Date mDateExpired;

    @com.google.gson.annotations.SerializedName("spoonacularid")
    private String mSpoonacularID;

    public FoodItem() {

    }

    @Override
    public String toString() {
        return getText();
    }

    public FoodItem(String text, String id) {
        this.setText(text);
        this.setId(id);
        //this.setDateAdded(new Date());
    }

    public String getText() {
        return mText;
    }

    public final void setText(String text) {
        mText = text;
    }

    public String getId() {
        return mId;
    }

    public final void setId(String id) {
        mId = id;
    }

    public Date getDateAdded() { return mDateAdded; }
    public final void setDateAdded(Date added) { mDateAdded = added; }

    public Date getDateExpired() { return mDateExpired; }
    public final void setDateExpired(Date expired) { mDateExpired = expired; }

    public boolean isComplete() {
        return mComplete;
    }

    public void setComplete(boolean complete) {
        mComplete = complete;
    }

    @Override
    public boolean equals(Object o) {
        return o instanceof FoodItem && ((FoodItem) o).mId == mId;
    }
}
