/** TRACCC library, part of the ACTS project (R&D line)
 *
 * (c) 2022-2024 CERN for the benefit of the ACTS project
 *
 * Mozilla Public License Version 2.0
 */

// Local include(s).
#include "traccc/options/track_resolution.hpp"

#include "traccc/examples/utils/printable.hpp"

// System include(s).
#include <iostream>

namespace traccc::opts {

/// Convenience namespace shorthand
namespace po = boost::program_options;

track_resolution::track_resolution()
    : interface("Track Ambiguity Resolution Options") {

    m_desc.add_options()("perform-ambiguity-resolution",
                         po::value(&run)->default_value(run),
                         "Perform track ambiguity resolution");
}

std::unique_ptr<configuration_printable> track_resolution::as_printable()
    const {
    std::unique_ptr<configuration_printable> cat =
        std::make_unique<configuration_category>(
            "Ambiguity resolution options");

    dynamic_cast<configuration_category &>(*cat).add_child(
        std::make_unique<configuration_kv_pair>("Run ambiguity resolution",
                                                run ? "yes" : "no"));

    return cat;
}
}  // namespace traccc::opts
