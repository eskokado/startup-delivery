require 'rails_helper'

RSpec.describe Manager::PostsController,
               type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }
  let(:post) { create(:post, client: client) }

  let(:posts) { create_list(:post, 3, client: client) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @posts' do
      post = FactoryBot.create(:post, client: client)
      get :index
      expect(assigns(:posts)).to eq([post])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns @posts for the given search parameters' do
      double('search_result', result: posts)
      allow(Post)
        .to receive_message_chain(:ransack, :result).and_return(posts)

      get :index

      expect(assigns(:posts)).to match_array(posts)
    end
  end

  describe 'GET #index with search' do
    it 'returns the posts searched correctly' do
      post1 = create(:post,
                     title: 'Como fazer Pizzas',
                     content: 'Content de Pizzas grandes',
                     client: client)
      post2 = create(:post,
                     title: 'Como fazer Sorvetes',
                     content: 'Content de Sorvetes sabor morango',
                     client: client)
      get :index,
          params: { q: { title_or_content_cont: 'grandes' } }

      expect(assigns(:posts)).to include(post1)
      expect(assigns(:posts)).to_not include(post2)
    end

    it 'excludes non-matching results' do
      create(:post, title: 'Non-Matching Category', client: client)

      get :index,
          params: { q: { title_or_content_cont: 'Pequeno' } }

      expect(assigns(:posts)).to be_empty
    end

    it 'renders the index template' do
      get :index,
          params: { q: { title_or_content_cont: 'Search Nothing' } }

      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Post to @post' do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested post to @post' do
      get :edit, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end

    it 'renders the edit template' do
      get :edit, params: { id: post.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the post' do
        patch :update, params: {
          id: post.id,
          post: { title: 'Novo Post', content: 'Novo content' }
        }
        post.reload
        expect(post.title).to eq('Novo Post')
        expect(post.content).to eq('Novo content')
      end

      it 'redirects to the post with a notice on successful update' do
        patch :update, params: {
          id: post.id,
          post: { title: 'Atualizado' }
        }
        expect(response).to redirect_to(manager_post_path(post))
      end
    end
  end

  describe 'GET #show' do
    before do
      get :show, params: { id: post.id }
    end

    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested post to @post' do
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'DELETE #destroy' do
    let!(:post) { create(:post, client: client) }

    it 'deletes the post' do
      expect do
        delete :destroy, params: { id: post.id }
      end.to change(Post, :count).by(-1)
    end

    it 'redirects to the posts index with a notice' do
      delete :destroy, params: { id: post.id }
      expect(response).to redirect_to(manager_posts_path)
    end
  end
end
