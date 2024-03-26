require 'rails_helper'

RSpec.feature 'Manager Goals', type: :feature do
  let!(:user) { FactoryBot.create(:user) }
  let!(:client) { FactoryBot.create(:client, user: user) }

  before(:each) do
    FactoryBot.create(:goal, client: client, name: 'Aprender Ruby')
    FactoryBot.create(:goal, client: client, name: 'Aprender Rails')
    login_as(user, scope: :user)
  end

  scenario 'list goals' do
    visit manager_goals_path

    expect(page).to have_text('Aprender Ruby')
    expect(page).to have_text('Aprender Rails')
  end

  scenario 'list goals action done' do
    visit manager_goals_path

    expect(page).to have_text('Fazer')

    click_button "#{convert_to_id(Goal.first)}-dropdown-button"
    click_link I18n.t('views.manager.goals.goal.done')

    expect(page).to have_text('Feito')
  end

  scenario 'list goals action many done', js: true do
    visit manager_goals_path

    expect(page).to have_text('Fazer')

    check "#{convert_to_id(Goal.first)}-checkbox"
    check "#{convert_to_id(Goal.last)}-checkbox"
    click_button 'actionsDropdownButton'
    click_button I18n.t('views.manager.goals.index.action_1')

    # Resolvido TODO: Problema com javascript, parece que o capybara não
    # executa o javascript
    expect(page).to have_text('Feito')
  end

  scenario 'create goal' do
    visit new_manager_goal_path

    find('#goal_name', match: :first).set('Aprender Ruby on Rails')
    click_button I18n.t('views.manager.goals.form.add_task')
    all(:css, '[id$=name]')[1].set('Curso de Ruby')
    all(:css, '[id$=name]')[2].set('Curso de Rails')
    expect(page).to have_button(I18n.t('views.manager.goals.new.save'))

    click_button I18n.t('views.manager.goals.new.save')

    # Resolvido TODO: Não redireciona a página ou demora para aparecer
    expect(page).to have_content('Meta cadastrada com sucesso.')
    expect(page).to have_content('Aprender Ruby on Rails')
    expect(page).to have_content('Curso de Ruby')
    expect(page).to have_content('Curso de Rails')
  end

  scenario 'show goal action done', js: true do
    visit manager_goal_path(Goal.first)

    click_link I18n.t('views.manager.goals.show.done')

    expect(page).to have_text(I18n.t('controllers.manager.goals.done.one'))
  end

  scenario 'show goal' do
    visit manager_goal_path(Goal.first)

    expect(page).to have_text('Aprender Ruby')
  end

  scenario 'update goal' do
    visit manager_goal_path(Goal.last)
    click_link I18n.t('views.manager.goals.goal.edit')

    fill_in 'Nome', with: 'Aprender Ruby on Rails'
    fill_in 'Descrição', with: 'Criar projeto editora de livro'
    click_button I18n.t('views.manager.goals.edit.save')

    # Resolvido TODO: Não redireciona a página ou demora para aparecer
    expect(page).to have_text('Meta atualizada com sucesso.')
    expect(page).to have_text('Aprender Ruby on Rails')
  end

  scenario 'delete goal' do
    visit manager_goal_path(Goal.first)
    click_link I18n.t('views.manager.goals.show.delete')

    # expect(page).to have_css('.modal')
    # puts "Texto do modal: #{page.find('.modal').text}"

    page.accept_alert I18n.t('views.manager.goals.show.delete_confirm')

    # Resolvido TODO: Não redireciona a página ou demora para aparecer
    expect(page).to have_text('Meta apagada com sucesso.')
    expect(page).not_to have_text('Aprender Ruby')
  end
end
