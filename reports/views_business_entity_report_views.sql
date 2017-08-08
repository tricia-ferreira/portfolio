SELECT
  entity.sub_id,
  entity.entity_type,
  entity.entity_id,
  entity.status,
  entity.trading_name,
  entity.address_id,
  entity.province,
  entity.kind,
  entity.latitude,
  entity.longitude,

  contact.first_name AS contact_first_name,
  contact.last_name AS contact_last_name,
  contact.telephone_number AS contact_telephone_number,
  contact.email AS contact_email,

  address.line_1 AS address_line_1,
  address.line_2 AS address_line_2,
  address.suburb AS address_suburb,
  address.city AS address_city,
  address.postal_code AS address_postal_code,

  business_group.name AS business_group_name,

  business.registered_name AS business_registered_name

FROM views_business_entity_matrows entity
  LEFT JOIN contacts contact ON
    contact.contacteable_id = entity.entity_id AND
    contact.contacteable_type = entity.entity_type AND
    contact.primary = true
  LEFT JOIN addresses address ON
    address.addressable_id = entity.entity_id AND
    address.addressable_type = entity.entity_type AND
    address.type = 'PhysicalAddress'
  LEFT JOIN business_groups business_group ON
    business_group.id = entity.business_group_id
  LEFT JOIN businesses business ON
    business.id = entity.business_id
