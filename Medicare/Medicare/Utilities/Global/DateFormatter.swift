//
//  DateFormatter.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import Foundation

// MARK: - Date Time

var yyyyMMddHHmmssZFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")

            return dateFormatter
        }()
    }

    return Static.instance
}

var yyyyMMddHHmmssFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")

            return dateFormatter
        }()
    }

    return Static.instance
}

var yyyyMMddHHmmssWithSlashDateColonTimeFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

            return dateFormatter
        }()
    }

    return Static.instance
}

var yyyyMMddHHmmssWithDashDateColonTimeFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            return dateFormatter
        }()
    }

    return Static.instance
}

var ddMMyyyyHHmmFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"

            return dateFormatter
        }()
    }

    return Static.instance
}

// MARK: - Date

var yyyyMMddFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            return dateFormatter
        }()
    }

    return Static.instance
}

var yyyyMMddWithDotFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"

            return dateFormatter
        }()
    }

    return Static.instance
}

var ddMMyyyyFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"

            return dateFormatter
        }()
    }

    return Static.instance
}

var yyyyMMddWithSlashFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"

            return dateFormatter
        }()
    }

    return Static.instance
}

var MMyyyyFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yyyy"

            return dateFormatter
        }()
    }

    return Static.instance
}

var MMMMFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"

            return dateFormatter
        }()
    }

    return Static.instance
}

var ddFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"

            return dateFormatter
        }()
    }

    return Static.instance
}

var yyyyMMddJPFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy年MM月dd日"

            return dateFormatter
        }()
    }

    return Static.instance
}

// MARK: - Time

var HHmmssFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"

            return dateFormatter
        }()
    }

    return Static.instance
}

var HHmmFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"

            return dateFormatter
        }()
    }

    return Static.instance
}
