class CookielawsController < ApplicationController

  # POST /cookielaws
  # POST /cookielaws.json
  def accept
    set_accept_cookie
    render 'new', locals: { cookie: true }
  end

  def refuse
    set_refuse_cookie
    render 'new', locals: { cookie: false }
  end

  def privacy
   #   set_refuse_cookie
   # render 'new', locals: { cookie: false }
  end

end

