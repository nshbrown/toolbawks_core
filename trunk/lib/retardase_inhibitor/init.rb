require 'retardase_inhibitor/lib/retardase_inhibitor'

ActionController::Base.send(:include, UrlWriterRetardaseInhibitor::ActionController)
ActionMailer::Base.send(:include, UrlWriterRetardaseInhibitor::ActionMailer)