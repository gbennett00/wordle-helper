require "application_system_test_case"

class WordsTest < ApplicationSystemTestCase
  setup do
    @word = words(:one)
  end

  test "visiting the index" do
    visit words_url
    assert_selector "h1", text: "Words"
  end

  test "should create word" do
    visit words_url
    click_on "New word"

    check "Used" if @word.used
    fill_in "Word", with: @word.word
    click_on "Create Word"

    assert_text "Word was successfully created"
    click_on "Back"
  end

  test "should update Word" do
    visit word_url(@word)
    click_on "Edit this word", match: :first

    check "Used" if @word.used
    fill_in "Word", with: @word.word
    click_on "Update Word"

    assert_text "Word was successfully updated"
    click_on "Back"
  end

  test "should destroy Word" do
    visit word_url(@word)
    click_on "Destroy this word", match: :first

    assert_text "Word was successfully destroyed"
  end
end
