require "okuribito"

module OkuribitoRails
  class ObserveMethod
    def patch_okuribito
      Okuribito::OkuribitoPatch.new(once_detect: OkuribitoRails.config.once_detect) do |method_name, _obj_name, caller_info, class_name, method_symbol|
        situation = MethodCallSituation.find_by(class_name: class_name,
                                                method_symbol: method_symbol,
                                                method_name: method_name)
        if situation.present?
          situation.increment!(:called_num)
          MethodCallLog.create(method_call_situation: situation,
                               class_name: class_name,
                               method_symbol: method_symbol,
                               method_name: method_name,
                               back_trace: caller_info[0])
        end
      end
    end
  end
end