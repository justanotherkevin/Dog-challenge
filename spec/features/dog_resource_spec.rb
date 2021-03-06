require 'rails_helper'

describe 'Dog resource', type: :feature do
  it 'can create a profile' do
    user = create(:user)
    sign_in(user)

    visit new_dog_path

    fill_in 'Name', with: 'Speck'
    fill_in 'Description', with: 'Just a dog'
    attach_file 'Image', 'spec/fixtures/images/speck.jpg'
    click_button 'Create Dog'
    expect(Dog.count).to eq(1)
  end

  it 'can edit a dog profile' do
    dog = create(:dog)
    sign_in(dog.owner)

    visit edit_dog_path(dog)
    fill_in 'Name', with: 'Speck'
    click_button 'Update Dog'
    expect(dog.reload.name).to eq('Speck')
  end

  it 'can delete a dog profile' do
    dog = create(:dog)
    sign_in(dog.owner)

    visit dog_path(dog)
    click_link "Delete #{dog.name}'s Profile"
    expect(Dog.count).to eq(0)
  end

  it 'can like a dog profile' do
    dog_one = create(:dog)
    dog_two = create(:dog)
    likes = dog_two.likes

    sign_in(dog_one.owner)
    visit dog_path(dog_two)
    click_button '❤️'

    expect(dog_two.reload.likes).to eq(likes+1)
  end

  it 'can not like your own dog profile' do
    dog = create(:dog)
    likes = dog.likes

    sign_in(dog.owner)
    visit dog_path(dog)
    click_button '❤️'

    expect(dog.reload.likes).to eq(likes)
  end
end
